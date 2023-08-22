
var rg = resourceGroup()

resource mi1 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'mi1'
  location: rg.location
}

resource mi2 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {

    name: 'mi2'
    location: rg.location
  }

  resource mi3 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
    
      name: 'mi3'
      location: rg.location
    }

    resource mi4 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
    
        name: 'mi4'
        location: rg.location
      }


