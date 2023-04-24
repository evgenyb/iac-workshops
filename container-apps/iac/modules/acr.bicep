@secure()
param location string
param acrPrivateDnsZoneId string
param privateLinkSubnetId string

var uniqueStr = uniqueString(subscription().subscriptionId, resourceGroup().id)
var acrName = 'iacws4${uniqueStr}acr'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Premium'
  }
  properties: {
    publicNetworkAccess: 'Disabled'
    networkRuleSet: {
      defaultAction: 'Deny'
      ipRules: []
    }
    adminUserEnabled: false
    networkRuleBypassOptions: 'AzureServices'    
  }
}

var pleName = '${acrName}-ple'
var groupName = 'registry' 

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: pleName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: pleName
        properties: {
          groupIds: [
            groupName
          ]
          privateLinkServiceId: acr.id
        }
      }
    ]
    subnet: {
      id: privateLinkSubnetId
    }
    customDnsConfigs: [
      {
        fqdn: '${acrName}.azurecr.io'
      }
    ]
  }
}

var privateDnsZoneName = 'privatelink.azurecr.io'
resource privateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-09-01' = {
  name: '${groupName}-PrivateDnsZoneGroup'
  parent: privateEndpoint
  properties:{
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties:{
          privateDnsZoneId: acrPrivateDnsZoneId
        }
      }
    ]
  }
}

// var acrPullRoleId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
// var acrPullADGroupObjectId = '02ebfd0b-5743-4651-b44b-56f78c815ce9' // BN-SEC: ACR Pull

// resource acrRoleAssignmentForAksMi 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   scope: acr
//   name: guid(acr.id, acrPullADGroupObjectId, acrPullRoleId)  
//   properties: {
//     principalId: acrPullADGroupObjectId
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
//   }
// }

output acrId string = acr.id
output acrName string = acr.name
