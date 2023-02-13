targetScope = 'subscription'
param adminUsername string = 'jamesbond'
param location string
@secure()
param adminPassword string
param virtualMachines array

var prefix = 'iac-ws2'
var vmAdminPasswordSecretName = 'vmadmin-password'
var hubResourceGroupName = '${prefix}-rg'

resource hubRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: hubResourceGroupName
  location: location
}

var keyvaultName = '${prefix}-${uniqueString(subscription().subscriptionId, hubResourceGroupName)}-kv'
module kv 'modules/keyvault.bicep' = {
  scope: hubRg
  name: 'kv'
  params: {
    location: location
    kvName: keyvaultName
    vmAdminPasswordSecretName: vmAdminPasswordSecretName
    vmAdminPasswordSecretValue: adminPassword
  }
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = [for (item, i) in virtualMachines: {
  name: '${prefix}-${item.location}-rg'
  location: item.location
}]

module vnet 'modules/vnet.bicep' = [for (item, i) in virtualMachines: {
  name: 'vnet'
  scope: rg[i]
  params: {
    location: item.location 
    prefix: prefix
    vnetConfig: item.vnetConfig
  }
}]


resource secretsKV 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
  scope: az.resourceGroup(subscription().subscriptionId, hubResourceGroupName)
}


module iis_vms 'modules/iis-vm.bicep' = [for (item, i) in virtualMachines: {
  name: 'iis-vm'
  scope: rg[i]
  dependsOn: [
    kv
  ]
  params: {
    location: item.location
    vmName: item.workloadVMName
    adminUsername: adminUsername
    adminPassword: secretsKV.getSecret(vmAdminPasswordSecretName)    
    subnetId: vnet[i].outputs.workloadSubnetId
    vmCount: item.vmCount
  }
}]

module test_vms 'modules/test-vm.bicep' = [for (item, i) in virtualMachines: {
  name: 'test-vm'
  scope: rg[i]
  dependsOn: [
    kv
  ]
  params: {
    location: item.location
    vmName: item.testVMName
    adminUsername: adminUsername
    adminPassword: secretsKV.getSecret(vmAdminPasswordSecretName)
    subnetId: vnet[i].outputs.workloadSubnetId
  }
}]
