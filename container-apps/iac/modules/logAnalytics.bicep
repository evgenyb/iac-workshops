param prefix string
param location string

var uniqueStr = uniqueString(subscription().subscriptionId, resourceGroup().id)
var logAnalyticsWorkspaceName = '${prefix}-${uniqueStr}-log'

var logAnalyticsRetentionInDays = 60

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: logAnalyticsRetentionInDays
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
output name string = logAnalyticsWorkspace.name
output id string = logAnalyticsWorkspace.id
