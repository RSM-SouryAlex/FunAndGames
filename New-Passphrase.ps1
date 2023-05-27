$json = "$home\downloads\SimpleWordList.json"
$Wordlist = "C:\Client\GitHub\CR3\EnterprisePasswordReset\wordlist.json"

$SimpleJSON = Get-Content "$home\downloads\SimpleWordList.json" | ConvertFrom-Json 
$SimpleJSON

cat $Wordlist | ConvertFrom-Json

$jsonfile = "C:\Client\GitHub\CR3\EnterprisePasswordReset\wordlist.json"
$json = Get-Content -Path $jsonfile -Raw | ConvertFrom-Json
$json += "hydrogen",
$json | ConvertTo-Json | Out-File -FilePath $jsonfile -Encoding UTF8

# RHYMES
cat $Wordlist | ConvertFrom-Json | % {$_ -like "*age"}
cat $Wordlist | ConvertFrom-Json | % {$_ -like "*ot"} | % {if($_ -notlike "*oot"){$_}}


$ud.word | Sort-Object | select -Unique | ConvertTo-Json | Out-File $home\desktop\UrbanWordList.json


function New-Passphrase
{
    [cmdletBinding()]
    Param
    (
        [parameter(Mandatory=$true)]
        $Json,

        [parameter()]
        [int]$Count
    )

    $WordString = [string]::join(" ",(cat $json | ConvertFrom-Json | Get-Random -Count $Count))
    $Capped = $WordString.Substring(0,1).toupper()+$WordString.Substring(1).tolower()
    $Password = $Capped + ' ' + (Get-Random -Minimum 1 -Maximum 100)
    Write-Output $Password  
}

New-Passphrase -Json $Wordlist -Count 5

New-Passphrase -Json "C:\Users\e060080\desktop\UrbanWordList.json" -Count 3



