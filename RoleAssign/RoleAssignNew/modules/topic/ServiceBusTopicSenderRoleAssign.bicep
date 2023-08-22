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
 name: managedIdentityName.topicWriterIdName
 scope: resourceGroup(managedIdentityName.topicWriterIdResourceGroup)
}
]


resource serviceBusSenderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for i in range(0,length(managedIdentityNamesArray)): {
  name: managedIdentityResourceArray[i].name 
  scope: serviceBusTopicResource
  properties: {
  description: roleAssignmentDescription 
  principalId: managedIdentityResourceArray[i].properties.principalId 
  roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','69a216fc-b8fb-44d8-bc22-1f3c2cd27a39')
  }
  }]



