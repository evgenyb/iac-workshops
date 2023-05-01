@secure()
param location string
param acrName string
param acrPrivateDnsZoneId string
param privateLinkSubnetId string
param acrPullObjectsIds array


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

var acrPullRoleId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource acrPull 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for objectId in acrPullObjectsIds: {
  scope: acr
  name: guid(acr.id, objectId, acrPullRoleId)  
  properties: {
    principalId: objectId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
  }
}]


output acrId string = acr.id
output acrName string = acr.name
