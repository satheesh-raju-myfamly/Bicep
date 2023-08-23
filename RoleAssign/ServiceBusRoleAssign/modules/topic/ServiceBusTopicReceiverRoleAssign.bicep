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

resource managedIdentityResourceArray 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = [for managedIdentityName in managedIdentityNamesArray :{
  name: managedIdentityName.topicReaderIdName
  scope: resourceGroup(managedIdentityName.topicReaderIdResourceGroup)
}
]


resource serviceBusReceiverRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for i in range(0,length(managedIdentityNamesArray)): {
  name: guid(managedIdentityResourceArray[i].name ,serviceBusTopicResource.id,resourceGroup().id) 
  scope: serviceBusTopicResource
  properties: {
  description: roleAssignmentDescription 
  principalId: managedIdentityResourceArray[i].properties.principalId 
  roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0')
  }
  }]


  resource topicReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for i in range(0,length(managedIdentityNamesArray)): {
    name: guid(managedIdentityResourceArray[i].name,serviceBusTopicResource.id,resourceGroup().id,'acdd72a7-3385-48ef-bd42-f606fba81ae7') 
    scope: serviceBusTopicResource
    properties: {
    description: roleAssignmentDescription 
    principalId: managedIdentityResourceArray[i].properties.principalId 
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')
    }
    }]

// module roleAssignModule '../role/RoleAssign.bicep'  =  [ for managedIdentity in managedIdentityNamesArray : {
//   name: guid(managedIdentity.topicWriterIdName,'roleAssignModule')
//   params: {
//     isTopic: true
//     serviceBusNameSpaceName: serviceBusNameSpaceName
//     resourceName: topicName
//     roleAssignmentDescription: roleAssignmentDescription
//     managedIdentityName: managedIdentity.topicWriterIdName
//     managedIdentityResourceGroup: managedIdentity.topicWriterIdResourceGroup
//     roleDefinitionIds: ['4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0','acdd72a7-3385-48ef-bd42-f606fba81ae7']
//   }
// }
// ]



