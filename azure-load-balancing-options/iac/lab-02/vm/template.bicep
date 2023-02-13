param location string = resourceGroup().location
param vmSize string = 'Standard_B2ms'
param adminUsername string = 'jamesbond'

var prefix = 'iac-ws2-lab02'

module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location 
    prefix: prefix
  }
}

module alb 'modules/alb.bicep' = {
  name: 'alb'
  params: {
    location: location
    prefix: prefix    
  }
}

var vmAdminPasswordSecretName = 'vmadmin-password'
var hubResourceGroupName = 'iac-ws2-rg'
var keyvaultName = '${prefix}-${uniqueString(subscription().subscriptionId, hubResourceGroupName)}-kv'

resource secretsKV 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
  scope: az.resourceGroup(subscription().subscriptionId, hubResourceGroupName)
}


module vm 'modules/vm.bicep' = {
  name: 'vms'
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: secretsKV.getSecret(vmAdminPasswordSecretName)    
    vmLoadBalancerBackendPoolId: alb.outputs.vmBackendPoolId
    outboundLoadBalancerBackendPoolId: alb.outputs.outboundBackendPoolId
    subnetId: vnet.outputs.workloadSubnetId
    vmSize: vmSize
  }
}
