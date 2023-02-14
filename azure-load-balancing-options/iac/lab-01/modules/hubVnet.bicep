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
        vnetConfig.addressPrefix
      ]
    }
    subnets: [
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: vnetConfig.bastionSubnetPrefix
        }
      }
      {
        name: 'agw-snet'
        properties: {
          addressPrefix: vnetConfig.agwSubnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }    
    ]
    enableDdosProtection: false
    enableVmProtection: false
  }
}

output bastionSubnetId string = '${vnet.id}/subnets/AzureBastionSubnet'
output agwSubnetId string = '${vnet.id}/subnets/agw-snet'
output name string = vnet.name  
