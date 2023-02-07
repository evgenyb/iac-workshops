@description('Admin username for the backend servers')
param adminUsername string = 'jamesbond'

@description('Password for the admin account on the backend servers')
@secure()
param adminPassword string

@description('Location for all resources.')
param location string = resourceGroup().location

var prefix = 'iac-ws2-lab02'
var vmScaleSetName = toLower(substring('ws2-vmss${uniqueString(resourceGroup().id)}', 0, 9))

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
    vmScaleSetName: vmScaleSetName
  }
}

module bastion 'modules/bastion.bicep' = {
  name: 'bastion'
  params: {
    location: location
    prefix: prefix
    bastionSubnetId: vnet.outputs.bastionSubnetId
  }
}

module vmss 'modules/vmScaleSet.bicep' = {
  name: 'vmss'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    loadBalancerBackendAddressPoolIDs: alb.outputs.backendPoolID
    location: location
    subnetId: vnet.outputs.vmSubnetId
    vmScaleSetName: vmScaleSetName
  }
}
