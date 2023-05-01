param privateDnsZoneName string
param linkedVNetId string
param domainNames array
param staticIP string

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

resource arecords 'Microsoft.Network/privateDnsZones/A@2020-06-01' = [for domain in domainNames: {
  name: domain
  parent: privateDnsZone
  properties: {
    ttl: 600
    aRecords: [
      {
        ipv4Address: staticIP
      }
    ]
  }
}]

output id string = privateDnsZone.id
