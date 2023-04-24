param location string
param prefix string
param vnetConfig object

var virtualNetworkName = '${prefix}-vnet'

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetConfig.vnetAddressPrefix
      ]
    }
    subnets: [for snet in vnetConfig.subnets: {
      name: snet.name
      properties: {        
        addressPrefix: snet.addressPrefix
      }
    }] 
    enableDdosProtection: false
    enableVmProtection: false
  }
}

output name string = vnet.name
output id string = vnet.id
