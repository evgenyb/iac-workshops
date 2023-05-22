param prefix string
param location string
param logAnalyticsName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsName 
} 

var containerAppsEnvironmentName = '${prefix}-public-cae'

resource menv 'Microsoft.App/managedEnvironments@2022-10-01' = {
  name: containerAppsEnvironmentName
  location: location
  sku: {
    name: 'Consumption'
  }  
  properties: {
    vnetConfiguration: {
      internal: false
    }
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }      
    zoneRedundant: false
  }
}

output environmentId string = menv.id
output defaultDomain string = menv.properties.defaultDomain
