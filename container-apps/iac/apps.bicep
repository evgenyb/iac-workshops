targetScope = 'resourceGroup'

param location string = resourceGroup().location

@description('Lab resources prefix.')
param prefix string = 'iac-ws4'

var uniqueStr = uniqueString(subscription().subscriptionId, resourceGroup().id)
var acrName = 'iacws4${uniqueStr}acr'
var privateManagedEnvironmentName = '${prefix}-private-cae'

var appInsightsName = '${prefix}-appi'
resource appInsights 'microsoft.insights/components@2020-02-02' existing = {
  name: appInsightsName
} 

var cosmosdbName = '${prefix}-cosmosdb'
resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosdbName
}

resource privateManagedEnvironment 'Microsoft.App/managedEnvironments@2022-10-01' existing = {
  name: privateManagedEnvironmentName
}

var privateAppName = '${prefix}-private-capp'
module privateAppMI 'modules/mi.bicep' = {
  name: 'privateAppMI'
  params: {
    location: location
    miName: '${privateAppName}-mi'
  }
}

module privateAppAcrPullRbac 'modules/acrrbac.bicep' = {
  name: 'privateAppAcrPullRbac'
  params: {
    acrName: acrName
    principalId: privateAppMI.outputs.principalId
  }
}


module testApp 'modules/private-capp.bicep' = {
  name: privateAppName
  dependsOn: [
    privateAppAcrPullRbac // we need to assign acrPull role to the MI before creating the app, so it can pull images from ACR
  ]
  params: {
    appName: privateAppName
    acrName: acrName
    location: location
    environmentId: privateManagedEnvironment.id
    managedIdentity: privateAppMI.outputs.id
    staticIP: privateManagedEnvironment.properties.staticIp
    privateDnsZoneName: privateManagedEnvironment.properties.defaultDomain
    appInsightsConnectionString: appInsights.properties.ConnectionString
    cosmosdbEndpoint: cosmosdb.properties.documentEndpoint
    cosmosdbKey: cosmosdb.listKeys().primaryMasterKey
  }
}

var publicManagedEnvironmentName = '${prefix}-public-cae'

resource publicManagedEnvironment 'Microsoft.App/managedEnvironments@2022-10-01' existing = {
  name: publicManagedEnvironmentName
}

var publicAppName = '${prefix}-public-capp'
module publicAppMI 'modules/mi.bicep' = {
  name: 'publicAppMI'
  params: {
    location: location
    miName: '${publicAppName}-mi'
  }
}

module publicAppAcrPullRbac 'modules/acrrbac.bicep' = {
  name: 'publicAppAcrPullRbac'
  params: {
    acrName: acrName
    principalId: privateAppMI.outputs.principalId
  }
}

module publicApp 'modules/public-capp.bicep' = {
  name: publicAppName
  dependsOn: [
    privateAppAcrPullRbac // we need to assign acrPull role to the MI before creating the app, so it can pull images from ACR
  ]
  params: {
    appName: publicAppName
    acrName: acrName
    location: location
    environmentId: publicManagedEnvironment.id
    managedIdentity: privateAppMI.outputs.id
    appInsightsConnectionString: appInsights.properties.ConnectionString
    cosmosdbEndpoint: cosmosdb.properties.documentEndpoint
    cosmosdbKey: cosmosdb.listKeys().primaryMasterKey
  }
}
