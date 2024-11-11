$ResourceGroup = "BasicRG"
$SqlServer = "simpleserver9"

function FindIPType {
	param($ipAddress)
	$ip = [System.Net.IPAddress]::Parse($ipAddress)
	if($ip.AddressFamily -eq 'InterNetworkV6') {
		Write-Output "$ipAddress is not a valid IPv4 address"
		return
	}
	
	$octects = $ipAddress -split '\.'
	
	if(($octects[0] -eq 10) -or
	   ($octects[0] -eq 172 -and $octects[1] -ge 16 -and $octects[1] -le 31) -or
	   ($octects[0] -eq 192 -and $octects[1] -eq 168)) {
	    	Write-Output "$ipAddress	Private address"
		} 
	else {
			Write-Output "$ipAddress	Public address"
	}
}

Get-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroup -ServerName $SqlServer > FirewallRules.txt
Get-Content -Path 'C:\TheCloudUniverse\PSscripts\FirewallRules.txt' |
	Select-String -Pattern '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b' -AllMatches |
	ForEach-Object { $_.Matches.Value } > IpsList.txt

$filePath = "C:\TheCloudUniverse\PSscripts\IpsList.txt"
$unique = Get-Content $filePath | Sort-Object | Get-Unique
Set-Content -Path $filePath -Value $unique

#Get the contnets of the filePath
$content = Get-Content -Path 'C:\TheCloudUniverse\PSscripts\IpsList.txt'

#loop
foreach ($line in $content) {
	FindIPType $line
}
Remove-Item C:\TheCloudUniverse\PSscripts\FirewallRules.txt
Remove-Item C:\TheCloudUniverse\PSscripts\IpsList.txt
