// serviceBusQueue.bicep
param queueName string = 'sbq8154learning'
param location string = resourceGroup().location

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: 'sb8154nslearning'
  location: location
  sku: {
    name: 'Standard'
    capacity: 1
    tier: 'Standard'
  }
   properties:{
     publicNetworkAccess:'Enabled'
   }
}
resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2021-01-01-preview' = {
  name: '${serviceBusNamespace.name}${queueName}'
  parent: serviceBusNamespace
}
