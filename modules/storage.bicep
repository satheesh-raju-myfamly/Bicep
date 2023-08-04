param storageName string
param location string = 'westus3'
param kindType string  = 'StorageV2'

resource storageaccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  kind: kindType
  sku: {
    name: 'Premium_LRS'
  }
}



