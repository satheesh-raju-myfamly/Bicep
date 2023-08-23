
resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: 'bicep-test-sbns'
  location: resourceGroup().location
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
  name: 'test_queue'
  parent: serviceBusNamespace
}

resource serviceBusTopic 'Microsoft.ServiceBus/namespaces/topics@2021-01-01-preview' = {
  name: 'test_topic'
  parent: serviceBusNamespace
}
