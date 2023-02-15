targetScope = 'subscription'
param adminUsername string = 'jamesbond'
param location string
@secure()
param adminPassword string
param virtualMachines array
param hubVnetConfig object
param signedInUserId string

var prefix = 'iac-ws2'
var vmAdminPasswordSecretName = 'vmadmin-password'
var hubResourceGroupName = '${prefix}-rg'

resource hubRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: hubResourceGroupName
  location: location
}

module agwPip 'modules/agw.bicep' = {
  scope: hubRg
  name: 'agwPip'
  params: {
    location: location
    prefix: prefix
  }
}

module hubVNet 'modules/hubVnet.bicep' = {
  name: 'hubVNet'
   scope: hubRg
   params: {
    location: location
    prefix: prefix
    vnetConfig: hubVnetConfig
   }
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
    signedInUserId: signedInUserId
  }
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = [for (item, i) in virtualMachines: {
  name: '${prefix}-${item.location}-rg'
  location: item.location
}]

module vnets 'modules/vnet.bicep' = [for (item, i) in virtualMachines: {
  name: 'vnet'
  scope: rg[i]
  params: {
    location: item.location 
    prefix: prefix
    vnetConfig: item.vnetConfig
  }
}]

module vnetToHubPeering 'modules/vnetPeering.bicep' = [for (item, i) in virtualMachines: {
  name: 'vnet-to-hub-peering'
  scope: rg[i]
  params: {
    fromVNetName: vnets[i].outputs.name
    toVNetName: hubVNet.outputs.name
    toVNetResourceGroupName: hubResourceGroupName
  }
}]

module hubToVNetPeering 'modules/vnetPeering.bicep' = [for (item, i) in virtualMachines: {
  name: 'hub-to-vnet-peering${i}'
  scope: hubRg
  params: {
    fromVNetName: hubVNet.outputs.name
    toVNetName: vnets[i].outputs.name
    toVNetResourceGroupName: rg[i].name
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
    subnetId: vnets[i].outputs.workloadSubnetId
    vmCount: item.vmCount
    path: item.path
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
    subnetId: vnets[i].outputs.workloadSubnetId
  }
}]

module bastion 'modules/bastion.bicep' = {
  name: 'bastion'
  scope: hubRg
  params: {
    location: location
    prefix: prefix
    bastionSubnetId: hubVNet.outputs.bastionSubnetId
  }
}
