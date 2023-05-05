param location string
param prefix string
param privateLinkSubnetId string
param linkedVNetId string
@secure()
param adminPassword string

var sqlServerName = '${prefix}-sql'
var pleName = '${sqlServerName}-ple'
var groupName = 'sqlServer' 

var privateDnsZoneName = 'privatelink.database.windows.net' 

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

resource sqlServer 'Microsoft.Sql/servers@2022-08-01-preview' = {
  name: sqlServerName
  location: location 
  properties: {    
    administratorLogin: 'sql-admin'
    administratorLoginPassword: adminPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    restrictOutboundNetworkAccess: 'Disabled'
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
          privateLinkServiceId: sqlServer.id
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

var databaseName = '${prefix}-sqldb' 
resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-08-01-preview' = {
  name: databaseName
  parent: sqlServer 
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
    zoneRedundant: false
    readScale: 'Disabled'
    highAvailabilityReplicaCount: 0
    autoPauseDelay: 0
    requestedBackupStorageRedundancy: 'Local'
    isLedgerOn: false
  }
}
