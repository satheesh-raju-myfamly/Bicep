@description ('The name of the managed identity resource')
param managedIdentityName string

@description('The IDs of the role definitions to assign to the managed identity. Each role assignment is created at the resource group scope')
param roleDefinitionIds array
@description('An optional description to apply to each role assignment, such as the reasda this managed identity needs to be granted the role')
param roleAssignmentDescription string=''


@description('topicName')
param topicName string

@description('serviceBusNamespaceName')
param serviceBusNamespaceName string


@description('The Azure location where the managed identity should be created.')
param location string = resourceGroup ().location

var roleAssignmentsToCreate = [for roleDefinitionId in roleDefinitionIds: {
name: guid(managedIdentity.id, resourceGroup(). id, roleDefinitionId) 
roleDefinitionId: roleDefinitionId
}]


resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentityName
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing ={
  name: serviceBusNamespaceName
  // location: location
  // sku: {
  //   name: 'Standard'
  //   capacity: 1
  //   tier: 'Standard'
  // }
  //  properties:{
  //    publicNetworkAccess:'Enabled'
  //  }
  
}

resource serviceBusTopic 'Microsoft.ServiceBus/namespaces/topics@2021-11-01' existing ={
  name: topicName
  parent: serviceBusNamespace
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for roleAssignmentTocreate in roleAssignmentsToCreate: {
name: roleAssignmentTocreate.name 
scope: serviceBusTopic
properties: {
description: roleAssignmentDescription 
principalId: managedIdentity.properties.principalId 
roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',roleAssignmentTocreate.roleDefinitionId)
// principalType: 'ServicePrincipal' // See https: //docs.microsoft.com/azure/role-based-access-control/role-assignments-template#new-service-principal to understand why
}
}]

@description ('The resource ID of the user-assigned managed identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The ID of the azure AD application associated with the managed identity.')
output managedIdentityclientId string = managedIdentity.properties.clientId

@description ('The ID of the Azure AD service principal associated with the managed identity.')
output managedIdentityPrincipalid string = managedIdentity.properties.principalId
