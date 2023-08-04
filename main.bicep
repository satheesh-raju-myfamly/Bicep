param location string = 'westus3'
param storageName string = 'raju8154'
param namePrefix string = 'raju'

targetScope = 'resourceGroup'

module storage 'modules/storage.bicep' = {
   name: storageName
   params:{
      storageName:storageName
      location:location
   }
}

module appPlan 'modules/servicePlan.bicep' = {
  name: '${namePrefix}-appPlan'
  params:{
    namePrefix: namePrefix
    location: location
  }
}

module webApp 'modules/webApp.bicep' = {
  name: '${namePrefix}-appDeploy'
  params: {
    appPlanId: appPlan.outputs.planId
    namePrefix: namePrefix
    location: location
  }
}


output siteurl string = webApp.outputs.siteurl

