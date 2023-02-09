param location string
param prefix string
param vnetConfig object

var virtualNetworkName = '${prefix}-${location}-vnet'

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
        name: 'workload-snet'
        properties: {
          addressPrefix: vnetConfig.workloadSubnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
    enableVmProtection: false
  }
}

output workloadSubnetId string = '${vnet.id}/subnets/workload-snet'
