param location string
param miName string 

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: miName
  location: location
}

output id string = mi.id
output clientId string = mi.properties.clientId
output principalId string = mi.properties.principalId
