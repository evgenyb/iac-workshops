targetScope = 'subscription'
param adminUsername string = 'jamesbond'
@secure()
param adminPassword string
param locations array

var prefix = 'iac-ws2'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = [for (item, i) in locations: {
  name: '${prefix}-${item.location}-rg'
  location: item.location
}]

module vnet 'modules/vnet.bicep' = [for (item, i) in locations: {
  name: 'vnet'
  scope: rg[i]
  params: {
    location: item.location 
    prefix: prefix
    vnetConfig: item.vnetConfig
  }
}]


module iis_vms 'modules/iis-vm.bicep' = [for (item, i) in locations: {
  name: 'iis-vm'
  scope: rg[i]
  params: {
    location: item.location
    vmName: item.workloadVMName
    adminUsername: adminUsername
    adminPassword: adminPassword    
    subnetId: vnet[i].outputs.workloadSubnetId
  }
}]

module test_vms 'modules/test-vm.bicep' = [for (item, i) in locations: {
  name: 'test-vm'
  scope: rg[i]
  params: {
    location: item.location
    vmName: item.testVMName
    adminUsername: adminUsername
    adminPassword: adminPassword    
    subnetId: vnet[i].outputs.workloadSubnetId
  }
}]
