param workloadName string
param environment string
param location string
param vnetConfig object
param tags object

var vnetName = 'iac-${workloadName}-${environment}-vnet'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  tags: tags
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
        name: 'workload-snet'
        properties: {
          addressPrefix: vnetConfig.workloadSubnetPrefix
        }
      }
    ]
  }
}

output bastionSubnetId string = '${vnet.id}/subnets/AzureBastionSubnet'
output workloadSubnetId string = '${vnet.id}/subnets/workload-snet'
output vnetName string = vnet.name
output vnetId string = vnet.id
