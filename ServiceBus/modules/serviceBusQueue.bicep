param namePrefix string
param serviceBusNameSpaceId object


resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview'={
  name:'${namePrefix}8154learning'
  
}
