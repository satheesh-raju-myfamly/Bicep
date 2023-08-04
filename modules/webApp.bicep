param location string = 'westus3'
param namePrefix string = 'raju'
param appPlanId string


resource webApplication 'Microsoft.Web/sites@2022-09-01' = {
  name: '${namePrefix}-swebsite'
  location: location
  properties: {
    serverFarmId: appPlanId
    httpsOnly:true
  }
}


output siteurl string = webApplication.properties.hostNames[0]

