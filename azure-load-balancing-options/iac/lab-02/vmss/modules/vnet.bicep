@description('Location for all resources.')
param location string
param prefix string

var virtualNetworkName = '${prefix}-vnet'
var virtualNetworkPrefix = '10.10.0.0/22'
var azureBastionSubnetPrefix = '10.10.0.0/24'
var backendSubnetPrefix = '10.10.2.0/24'

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: '${prefix}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHTTPInbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

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
        name: 'vm-snet'
        properties: {
          addressPrefix: backendSubnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
    enableDdosProtection: false
    enableVmProtection: false
  }
}

output bastionSubnetId string = '${vnet.id}/subnets/AzureBastionSubnet'
output vmSubnetId string = '${vnet.id}/subnets/vm-snet'
