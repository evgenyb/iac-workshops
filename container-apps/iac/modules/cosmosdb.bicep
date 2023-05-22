param location string
param prefix string

var cosmosdbName = '${prefix}-cosmosdb'

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
    publicNetworkAccess: 'Enabled'
    databaseAccountOfferType: 'Standard'
  }
}

output endpoint string = cosmosdb.properties.documentEndpoint
