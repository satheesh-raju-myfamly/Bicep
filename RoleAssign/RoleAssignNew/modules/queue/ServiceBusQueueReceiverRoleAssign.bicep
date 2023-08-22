@description('the name of the service bus namespace')
param serviceBusNameSpaceName string
@description('the name of the service bus queue name')
param queueName string
@description('the managed identity names array')
param managedIdentityNamesArray array

@description('the role assignment description')
param roleAssignmentDescription string


resource serviceBusNameSpaceResource 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: serviceBusNameSpaceName
}

resource serviceBusQueueResource 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' existing = {
  name: queueName
  parent:serviceBusNameSpaceResource
}

resource managedIdentityResourceArray 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = [for managedIdentityName in managedIdentityNamesArray :{
  name: managedIdentityName.queueReaderIdName
  scope: resourceGroup(managedIdentityName.queueReaderIdResourceGroup) 
}
]


resource serviceBusReceiverRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for i in range(0,length(managedIdentityNamesArray)): {
  name: guid(managedIdentityResourceArray[i].name,serviceBusQueueResource.id,resourceGroup().id)   
  scope: serviceBusQueueResource
  properties: {
  description: roleAssignmentDescription 
  principalId: managedIdentityResourceArray[i].properties.principalId 
  roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0')
  }
  }]

  



