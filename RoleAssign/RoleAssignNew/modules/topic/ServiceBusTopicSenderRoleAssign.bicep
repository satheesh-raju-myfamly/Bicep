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
 name: managedIdentityName.topicWriterIdName
 scope: resourceGroup(managedIdentityName.topicWriterIdResourceGroup)
}
]


