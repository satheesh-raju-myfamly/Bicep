param location string = resourceGroup().location
param namePrefix string = 'sbl8154'


targetScope='resourceGroup'

module serviceBus 'modules/serviceBus.bicep' = {
name: 'serviceBus8154'
params: {
   location: location
   serviceBusNameSpacePrefix: namePrefix
   sku: 'Basic'
   tier:'Basic'
}

}


