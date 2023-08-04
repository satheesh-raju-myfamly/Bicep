param serviceBusNameSpacePrefix string
param location string
param sku string
param tier string


resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: '${serviceBusNameSpacePrefix}learning'
  location: location
  sku: {
    name: sku
    capacity: 1
    tier: tier
  }
   properties:{
     publicNetworkAccess:'Enabled'
   }
}


