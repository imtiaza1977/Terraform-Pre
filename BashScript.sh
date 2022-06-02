#!/bin/bash -e
az login
az account set --subscription "Terraform-Deployment" 

#Set variables for Storage Account and Key Vault that support the Terraform Implementation
RESOURCE_GROUP_NAME="demo-infra-rg"
STORAGE_ACCOUNT_NAME="demostg"
CONTAINER_NAME="democontainer"
STATE_FILE="demo.state"

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location koreacentral


# Create storage account.
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob


# Get storage account key 
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)


# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

# Show detail for the purpose of this code
echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
echo "state_file: $STATE_FILE"

# Create keyvault and example of Storing a Key
az keyvault create --name "demokvadeel" --resource-group "demo-infra-rg" --location westus2
az keyvault secret set --vault-name "demokvadeel" --name "demostateaccess" --value {$ACCOUNT_KEY}
az keyvault secret show --vault-name "demokvadeel" --name "demostateaccess"
