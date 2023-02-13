@description('Location for all resources.')
param location string
param prefix string

var virtualNetworkName = '${prefix}-vnet'
var virtualNetworkPrefix = '10.30.0.0/22'
var workloadSubnetPrefix = '10.30.0.0/24'


resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkPrefix
      ]
    }
    subnets: [
      {
        name: 'workload-snet'
        properties: {
          addressPrefix: workloadSubnetPrefix
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
