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

module acrPullRbac 'modules/acrrbac.bicep' = {
  name: 'acrPullRbac'
  params: {
    acrName: acrName
    principalId: mi.outputs.principalId
  }
}

var appInsightsName = '${prefix}-appi'
resource appInsights 'microsoft.insights/components@2020-02-02' existing = {
  name: appInsightsName
} 

var cosmosdbName = '${prefix}-cosmosdb'
resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosdbName
}

module testApp 'modules/testapp.bicep' = {
  name: testAppName
  dependsOn: [
    acrPullRbac // we need to assign acrPull role to the MI before creating the app, so it can pull images from ACR
  ]
  params: {
    appName: testAppName
    acrName: acrName
    location: location
    environmentId: privateManagedEnv.id
    managedIdentity: mi.outputs.id
    staticIP: privateManagedEnv.properties.staticIp
    privateDnsZoneName: privateManagedEnv.properties.defaultDomain
    appInsightsConnectionString: appInsights.properties.ConnectionString
    cosmosdbEndpoint: cosmosdb.properties.documentEndpoint
    cosmosdbKey: cosmosdb.listKeys().primaryMasterKey
  }
}
