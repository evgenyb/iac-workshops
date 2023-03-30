param prefix string
param location string

var logAnalyticsName = '${prefix}-${uniqueString(subscription().subscriptionId, resourceGroup().id)}-la'

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output workspaceResourceId string = workspace.id
