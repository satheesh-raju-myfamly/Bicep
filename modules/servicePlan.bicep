param namePrefix string
param location string =resourceGroup().location
param sku string = 'B1'


resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${namePrefix}-website'
  location: location
  sku: {
    name: sku
    capacity: 1
  }
}

output planId string = appServicePlan.id

