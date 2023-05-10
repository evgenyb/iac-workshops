param location string
param prefix string
param privateLinkSubnetId string
param linkedVNetId string


var cosmosdbName = '${prefix}-cosmosdb'

var pleName = '${cosmosdbName}-ple'
var groupName = 'sql' 

var privateDnsZoneName = 'privatelink.documents.azure.com' 

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource privateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: uniqueString(linkedVNetId)
  parent: privateDnsZone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: linkedVNetId
    }
  }  
}


resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' = {
  name: cosmosdbName
  location: location
  kind: 'GlobalDocumentDB'
  
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]    
    minimalTlsVersion: 'Tls12'
    publicNetworkAccess: 'Disabled'
    databaseAccountOfferType: 'Standard'
  }
}

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
          privateLinkServiceId: cosmosdb.id
        }
      }
    ]
    subnet: {
      id: privateLinkSubnetId
    }
  }
}

resource privateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-09-01' = {
  name: '${groupName}-PrivateDnsZoneGroup'
  parent: privateEndpoint
  properties:{
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties:{
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}

output key string = listKeys(cosmosdb.id, cosmosdb.apiVersion).primaryMasterKey
output endpoint string = cosmosdb.properties.documentEndpoint
