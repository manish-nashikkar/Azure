$sourceResourceGroup = "SourceRG"
$destinationResourceGroup = "DestinationRG"
$srcSA = "srcsa"
$destSA = "dstnsa"

# Generate SAS for storage accounts
$connectionStringsrcSA = az storage account show-connection-string --resource-group $sourceResourceGroup --name $srcSA  --query connectionString -o tsv
$srcSAS = az storage account generate-sas --connection-string $connectionStringsrcSA --account-name $srcSA --expiry (Get-Date).AddDays(+1).ToString('yyyy-MM-dd') --https-only --permissions acdlpruwy --resource-types sco --services bfqt -o tsv
$connectionStringdestSA = az storage account show-connection-string --resource-group $destinationResourceGroup --name $destSA  --query connectionString -o tsv
$destSAS = az storage account generate-sas --connection-string $connectionStringdestSA --account-name $destSA --expiry (Get-Date).AddDays(+1).ToString('yyyy-MM-dd') --https-only --permissions acdlpruwy --resource-types sco --services bfqt -o tsv

# Get all the containers from source storage account
$containers = (
    'container101',
    'container202'
)

# Sync source and destination storage accounts
foreach ($container in $containers) {
$source = "https://$srcSA.blob.core.windows.net/"+$container+"?"+$srcSAS
$destination = "https://$destSA.blob.core.windows.net/"+$container+"?"+$destSAS
Write-host "Syncing $Container ....."
C:\azcopy\azcopy.exe sync --delete-destination=true $source $destination
}
