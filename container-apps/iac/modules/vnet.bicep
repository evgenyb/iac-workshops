param location string
param prefix string
param vnetAddressPrefix string

var virtualNetworkName = '${prefix}-vnet'

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '${vnetAddressPrefix}.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'AzureBastionSubnet'
        properties: {        
          addressPrefix: '${vnetAddressPrefix}.0.0/26'
        }
      }
      {
        name: 'capp-snet'
        properties: {        
          addressPrefix: '${vnetAddressPrefix}.2.0/23'
        }
      }
      {
        name: 'testvm-snet'
        properties: {        
          addressPrefix: '${vnetAddressPrefix}.0.64/26'
        }
      }
      {
        name: 'plinks-snet'
        properties: {        
          addressPrefix: '${vnetAddressPrefix}.1.0/24'
        }
      }
    ] 
    enableDdosProtection: false
    enableVmProtection: false
  }
}

output name string = vnet.name
output id string = vnet.id
