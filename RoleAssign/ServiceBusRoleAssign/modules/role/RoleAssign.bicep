param roleDefinitionIds array
param serviceBusNameSpaceName string
param managedIdentityName string
param managedIdentityResourceGroup string
param roleAssignmentDescription string
param resourceName string
param isTopic bool 


resource serviceBusNameSpaceResource 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: serviceBusNameSpaceName
}

resource serviceBusQueueResource 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' existing = if(!isTopic) {
  name: resourceName
  parent:serviceBusNameSpaceResource
}

resource serviceBusTopicResource 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' existing = if(isTopic) {
  name: resourceName
  parent:serviceBusNameSpaceResource
}


resource managedIdentityResource 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentityName
  scope: resourceGroup(managedIdentityResourceGroup)
}


resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for roleDefinitionId in roleDefinitionIds: {
  name: guid(roleDefinitionId,managedIdentityResource.id,serviceBusQueueResource.id,resourceGroup().id)  
  scope: isTopic ?serviceBusTopicResource : serviceBusQueueResource
  properties: {
  description: roleAssignmentDescription 
  principalId: managedIdentityResource.properties.principalId 
  roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',roleDefinitionId)
  }
  }]
