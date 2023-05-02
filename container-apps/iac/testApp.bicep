targetScope = 'resourceGroup'

param location string = resourceGroup().location

@description('Lab resources prefix.')
param prefix string = 'iac-ws4'

var uniqueStr = uniqueString(subscription().subscriptionId, resourceGroup().id)
var acrName = 'iacws4${uniqueStr}acr'

resource privateManagedEnv 'Microsoft.App/managedEnvironments@2022-10-01' existing = {
  name: '${prefix}-private-menv'
}

var testAppName = '${prefix}-test-capp'
module mi 'modules/mi.bicep' = {
  name: 'testAppMI'
  params: {
    location: location
    miName: '${testAppName}-mi'
  }
}

module testApp 'modules/testapp.bicep' = {
  name: testAppName
  params: {
    appName: testAppName
    acrName: acrName
    location: location
    environmentId: privateManagedEnv.id
    managedIdentity: mi.outputs.id
    staticIP: privateManagedEnv.properties.staticIp
    privateDnsZoneName: privateManagedEnv.properties.defaultDomain
  }
}

module acrPullRbac 'modules/acrrbac.bicep' = {
  name: 'acrPullRbac'
  params: {
    acrName: acrName
    principalId: mi.outputs.principalId
  }
}
