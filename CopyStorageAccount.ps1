$sourceResourceGroup = "SourceRG"
$destinationResourceGroup = "DestinationRG"
$srcSA = "srcsa"
$destSA = "dstnsa"

# Generate SAS for storage accounts
$connectionStringsrcSA = az storage account show-connection-string --resource-group $sourceResourceGroup --name $srcSA  --query connectionString -o tsv
$srcSAS = az storage account generate-sas --connection-string $connectionStringsrcSA --account-name $srcSA --expiry (Get-Date).AddDays(+1).ToString('yyyy-MM-dd') --https-only --permissions acdlpruwy --resource-types sco --services bfqt -o tsv
$connectionStringdestSA = az storage account show-connection-string --resource-group $destinationResourceGroup --name $destSA  --query connectionString -o tsv
$destSAS = az storage account generate-sas --connection-string $connectionStringdestSA --account-name $destSA --expiry (Get-Date).AddDays(+1).ToString('yyyy-MM-dd') --https-only --permissions acdlpruwy --resource-types sco --services bfqt -o tsv

$source = "https://$srcSA.blob.core.windows.net/"+"?"+$srcSAS
$destination = "https://$destSA.blob.core.windows.net/"+"?"+$destSAS

# Copy storage account blob containers
Write-host "Copying blob containers..."
C:\azcopy\azcopy.exe copy $source $destination --recursive
