param prefix string
param location string
param logAnalyticsName string
param subnetId string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsName 
} 

var containerAppsEnvironmentName = '${prefix}-private-menv'

resource menv 'Microsoft.App/managedEnvironments@2022-10-01' = {
  name: containerAppsEnvironmentName
  location: location
  sku: {
    name: 'Consumption'
  }  
  properties: {
    vnetConfiguration: {
      internal: true
      infrastructureSubnetId: subnetId
    }
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: listKeys(logAnalyticsWorkspace.id, logAnalyticsWorkspace.apiVersion).primarySharedKey
      }
    }      
    zoneRedundant: false
  }
}

output environmentId string = menv.id
output staticIP string = menv.properties.staticIp
output defaultDomain string = menv.properties.defaultDomain
