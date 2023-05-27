$UD = ipcsv $home\desktop\ud.csv
$UD += ipcsv $home\desktop\ud2.csv
$UD += ipcsv $home\desktop\ud3.csv

$UD | sort Word | epcsv $Home\desktop\udPlus.csv -NoTypeInformation

$UD | group Word | ? Count -gt 1 | sort name | select Name


$UDPlus = ipcsv $home\desktop\udplus.csv 
[System.Collections.ArrayList]$array = @()
foreach($i in $UDPlus)
{
    $obj = "" | Select 'Word','Definition','Example'
    $check = ipcsv $Home\desktop\udplus.csv | Where Word -eq 'Valley Boy'
    if(($check).count -gt 1)
    {
       $obj.word = $check[0].word
       $obj.Definition = $check[0].Definition
       $obj.Example = $check[0].Example
       $array += $obj
       $obj = $Null
    }
    else
    {
       $obj.word = $check[0].word
       $obj.Definition = $check[0].Definition
       $obj.Example = $check[0].Example
       $array += $obj
       $obj = $Null    
    }
}
$array

$u = ipcsv $home\desktop

[string]::join(' ', ($ud.word | Get-Random -Count 4)) 

$ud.word | select -Unique

function New-Passphrase
{
    [cmdletBinding()]
    Param
    (
        [parameter()]
        $count
    )

    $UD = ipcsv $home\desktop\urbanDlist.csv

    [int]$x = '0'
    do
    {
        [string]::join(' ', ($ud.word | Get-Random -Count 4)) 
        $x++
        Write-Host ''
    }
    until ($x -eq $count)
}

New-Passphrase -count 10

'@ggro ghost Tabasco napkin'