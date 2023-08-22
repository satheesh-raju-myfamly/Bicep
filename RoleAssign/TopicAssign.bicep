// param serviceBusNamespaceName string
// param topicName string
// param managedIdentityName string

//   resource serviceBusTopic 'Microsoft.ServiceBus/namespaces/topics@2021-11-01' existing ={
//      name: topicName
//   }

//   resource roleAssignments3 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//     name: guid(serviceBusNamespaceName, topicName, managedIdentityName)
//     scope: serviceBusTopic
//     properties: {
//       principalId: reference(resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', managedIdentityName), '2021-06-01').principalId
//       roleDefinitionId: '/subscriptions/<subscription-id>/providers/Microsoft.Authorization/roleDefinitions/46762327-c5e9-40c1-8f28-3ecf5e478784' // "Listen" role definition ID
//     }
//   }

