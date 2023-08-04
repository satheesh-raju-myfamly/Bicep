param location string = resourceGroup().location
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


resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'xyz${storageName}'
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource webApplication 'Microsoft.Web/sites@2022-09-01' = {
  name: 'zed${storageName}'
  location: location

  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}




