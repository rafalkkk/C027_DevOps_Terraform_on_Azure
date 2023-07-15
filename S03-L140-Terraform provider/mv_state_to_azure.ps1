$RESOURCE_GROUP_NAME='tfstate'
$STORAGE_ACCOUNT_NAME="tfstate$(Get-Random)"
$CONTAINER_NAME='tfstate'

az group create --name $RESOURCE_GROUP_NAME --location eastus

az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

$ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

$env:ARM_ACCESS_KEY=$ACCOUNT_KEY


Write-Output $RESOURCE_GROUP_NAME
Write-Output $STORAGE_ACCOUNT_NAME
Write-Output $CONTAINER_NAME
Write-Output $env:ARM_ACCESS_KEY
