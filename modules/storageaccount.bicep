param storageAccountName string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

output endpoint string = storageAccount.properties.primaryEndpoints.blob
