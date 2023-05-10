param location string
param acrName string

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Premium'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    networkRuleSet: {
      defaultAction: 'Allow'
      ipRules: []
    }
    adminUserEnabled: false
    networkRuleBypassOptions: 'AzureServices'    
  }
}

output acrId string = acr.id
output acrName string = acr.name
