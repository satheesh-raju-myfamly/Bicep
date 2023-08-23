@description('the name of the service bus namespace')
param serviceBusNameSpaceName string

@description('the topics role assign data object')
param topicObjArray array

@description('the queues role assign data object')
param queueObjArray array

@description('the role assignment description')
param roleAssignmentDescription string

targetScope = 'resourceGroup'

module ServiceBusTopicSenderRoleAssign 'modules/topic/ServiceBusTopicSenderRoleAssign.bicep'  =  [ for topicObj in topicObjArray : {
   name: guid(topicObj.topicName,'ServiceBusTopicSenderRoleAssign')
   params: {
     serviceBusNameSpaceName: serviceBusNameSpaceName
     topicName: topicObj.topicName
     roleAssignmentDescription: roleAssignmentDescription
     managedIdentityNamesArray: topicObj.topicWriterIds
   }
}
]

module ServiceBusTopicReceiverRoleAssign 'modules/topic/ServiceBusTopicReceiverRoleAssign.bicep'  =  [ for topicObj in topicObjArray : {
  name: guid(topicObj.topicName,'ServiceBusTopicReceiverRoleAssign')
  params: {
    serviceBusNameSpaceName: serviceBusNameSpaceName
    topicName: topicObj.topicName
    roleAssignmentDescription: roleAssignmentDescription
    managedIdentityNamesArray: topicObj.topicReaderIds
  }
}
]


module ServiceBusQueueSenderRoleAssign 'modules/queue/ServiceBusQueueSenderRoleAssign.bicep'  =  [ for queueObj in queueObjArray : {
  name: guid(queueObj.queueName,'ServiceBusQueueSenderRoleAssign')
  params: {
    serviceBusNameSpaceName: serviceBusNameSpaceName
    queueName: queueObj.queueName
    roleAssignmentDescription: roleAssignmentDescription
    managedIdentityNamesArray: queueObj.queueWriterIds
  }
}
]

module ServiceBusQueueReceiverRoleAssign 'modules/queue/ServiceBusQueueReceiverRoleAssign.bicep'  =  [ for queueObj in queueObjArray : {
 name: guid(queueObj.queueName,'ServiceBusQueueReceiverRoleAssign')
 params: {
   serviceBusNameSpaceName: serviceBusNameSpaceName
   queueName: queueObj.queueName
   roleAssignmentDescription: roleAssignmentDescription
   managedIdentityNamesArray: queueObj.queueReaderIds
 }
}
]



