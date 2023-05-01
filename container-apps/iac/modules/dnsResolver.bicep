param location string
param prefix string
param subnetId string
param vnetId string

var dnsResolverName = '${prefix}-dnsresolver'

resource dnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: dnsResolverName
  location: location
  properties: {
    virtualNetwork: {
      id: vnetId
    }
  }
}

resource inboundEndpoinr 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = {
  name: 'inbound'
  parent: dnsResolver
  location: location
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: subnetId
        }
        privateIpAllocationMethod: 'Dynamic'
      }
    ]
  }
}
