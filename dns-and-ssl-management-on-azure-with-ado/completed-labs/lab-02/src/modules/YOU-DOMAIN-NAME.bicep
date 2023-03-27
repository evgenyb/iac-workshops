param tags object

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
