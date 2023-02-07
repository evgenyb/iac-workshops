@description('Location for all resources.')
param location string
param prefix string

var virtualNetworkName = '${prefix}-vnet'
var virtualNetworkPrefix = '10.10.0.0/22'
var azureBastionSubnetPrefix = '10.10.0.0/24'
var subnetPrefix = '10.10.1.0/24'
var backendSubnetPrefix = '10.10.2.0/24'


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
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: azureBastionSubnetPrefix
        }
      }
      {
        name: 'agw-snet'
        properties: {
          addressPrefix: subnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'vm-snet'
        properties: {
          addressPrefix: backendSubnetPrefix
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
output vmSubnetId string = '${vnet.id}/subnets/vm-snet'
