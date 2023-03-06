targetScope = 'subscription'
param location string
param signedInUserId string

var prefix = 'iac-ws3'

var resourseGroupName = '${prefix}-rg'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourseGroupName
  location: location
}

module kv 'modules/keyvault.bicep' = {
  name: '${prefix}-kv'
  scope: resourceGroup
  params: {
    prefix: prefix
    location: location
    signedInUserId: signedInUserId
  }
}
