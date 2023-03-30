param tags object
param dnsZoneContributors array

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'YOU-DOMAIN-NAME'
  location: 'global'
  tags: tags  
}

resource foobar 'Microsoft.Network/dnsZones/A@2018-05-01' = {
  name: 'foobar'
  parent: dnsZone
  properties: {
    TTL: 600
    ARecords: [
      {
        ipv4Address: '10.10.0.1'
      }
    ]
  }
}

var dnsZoneContributorRoleId = 'befefa01-2a29-4197-83a8-272ff33ce314' // https://www.azadvertizer.net/azrolesadvertizer/befefa01-2a29-4197-83a8-272ff33ce314.html

resource administratorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for dnsZoneContributor in dnsZoneContributors: {
  scope: dnsZone
  name: guid(dnsZone.id, dnsZoneContributor, dnsZoneContributorRoleId)  
  properties: {
    principalId: dnsZoneContributor
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', dnsZoneContributorRoleId)
  }  
}]
