# create resource group
az group create --name rg-bicep-webapp --location westeurope

# preview changes
az deployment group what-if --resource-group rg-bicep-webapp \
   --template-file webapp-linux.bicep \
   --parameters webAppName='webapp-test'

# deploy the web app using Bicep
az deployment group create --resource-group rg-bicep-webapp \
   --template-file webapp-linux.bicep \
   --parameters webAppName='webapp-text'