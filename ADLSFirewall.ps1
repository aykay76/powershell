Param(
    [string]$DataLakeName,
    [string]$Region = "europewest"
)

Function Get-IPV4NetworkStartIP ($strNetwork)
{
    $StrNetworkAddress = ($strNetwork.split("/"))[0]
    $NetworkIP = ([System.Net.IPAddress]$StrNetworkAddress).GetAddressBytes()
    [Array]::Reverse($NetworkIP)
    $NetworkIP = ([System.Net.IPAddress]($NetworkIP -join ".")).Address
    $StartIP = $NetworkIP +1
    #Convert To Double
    If (($StartIP.Gettype()).Name -ine "double")
    {
        $StartIP = [Convert]::ToDouble($StartIP)
    }
    $StartIP = [System.Net.IPAddress]$StartIP
    Return $StartIP
}

Function Get-IPV4NetworkEndIP ($strNetwork)
{
    $StrNetworkAddress = ($strNetwork.split("/"))[0]
    [int]$NetworkLength = ($strNetwork.split("/"))[1]
    $IPLength = 32-$NetworkLength
    $NumberOfIPs = ([System.Math]::Pow(2, $IPLength)) -1
    $NetworkIP = ([System.Net.IPAddress]$StrNetworkAddress).GetAddressBytes()
    [Array]::Reverse($NetworkIP)
    $NetworkIP = ([System.Net.IPAddress]($NetworkIP -join ".")).Address
    $EndIP = $NetworkIP + $NumberOfIPs
    If (($EndIP.Gettype()).Name -ine "double")
    {
        $EndIP = [Convert]::ToDouble($EndIP)
    }
    $EndIP = [System.Net.IPAddress]$EndIP
    Return $EndIP
}

Get-AzureRmDataLakeStoreFirewallRule -Account $DataLakeName | Remove-AzureRmDataLakeStoreFirewallRule

$tuesday = Get-Date
while ($tuesday.DayOfWeek -ne 'Tuesday')
{
    $tuesday = $tuesday.AddDays(-1)
}
$uri = "https://download.microsoft.com/download/0/1/8/018E208D-54F8-44CD-AA26-CD7BC9524A8C/PublicIPs_$($tuesday.ToString("yyyyMMdd")).xml"
[xml]$doc = (New-Object System.Net.WebClient).DownloadString($uri)

$i = 1
($doc.AzurePublicIpAddresses.Region | Where-Object { $_.Name -eq $Region }).IpRange | ForEach-Object {
    $start = Get-IPV4NetworkStartIP -strNetwork $_.Subnet
    $end = Get-IPV4NetworkEndIP -strNetwork $_.Subnet
    
    Add-AzureRmDataLakeStoreFirewallRule -Account $DataLakeName -Name "WestEurope$i" -StartIpAddress $start.IPAddressToString -EndIpAddress $end.IPAddressToString
    
    $i++
}
