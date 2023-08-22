@description('the name of the service bus namespace')
param serviceBusNameSpaceName string
@description('the name of the service bus topic name')
param topicName string
@description('the managed identity names array')
param managedIdentityNamesArray array

@description('the role assignment description')
param roleAssignmentDescription string


resource serviceBusNameSpaceResource 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: serviceBusNameSpaceName
}

resource serviceBusTopicResource 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' existing = {
  name: topicName
  parent:serviceBusNameSpaceResource
}

resource managedIdentityResourceArray 'Microsoft.ManagedIdentity/identities@2023-01-31' existing = [for managedIdentityName in managedIdentityNamesArray :{
  name: managedIdentityName.topicReaderIdName
  scope: resourceGroup(managedIdentityName.topicReaderIdResourceGroup)
}
]


resource serviceBusSenderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for i in range(0,length(managedIdentityNamesArray)): {
  name: managedIdentityResourceArray[i].name 
  scope: serviceBusTopicResource
  properties: {
  description: roleAssignmentDescription 
  principalId: managedIdentityResourceArray[i].properties.principalId 
  roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0')
  }
  }]



