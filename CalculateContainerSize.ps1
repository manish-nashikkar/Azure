$ResourceGroup = "MyResourceGroup"
$StorageAccount = "mytestsa2023"
$containerName = ""

#Get a reference to the srorage account and the context
$SA = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccount
$context = $SA.Context
$containers = Get-AzStorageContainer -Context $context
Write-Host "Size of containers from $StorageAccount"
foreach ($container in $containers) {
	$containerName = $container.Name
	
	# Get the total size of the blobs in the container
	$blobs = Get-AzStorageBlob -Context $context -Container $containerName
	$totalSize = ($blobs | Measure-Object -Property Length -Sum).Sum
	
	Write-Host "Container: $containerName, Size: $totalSize bytes"
}
