param location string = 'westus3'
param storageName string = 'space${uniqueString(resourceGroup().id)}'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageName
  properties:{
    accessTier:'Hot'
  }
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}
