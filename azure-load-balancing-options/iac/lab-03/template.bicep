@description('Admin username for the backend servers')
param adminUsername string = 'jamesbond'

@description('Password for the admin account on the backend servers')
@secure()
param adminPassword string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Size of the virtual machine.')
param vmSize string = 'Standard_B2ms'

var prefix = 'iac-ws2-lab03'

module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location 
    prefix: prefix
  }
}

module agw 'modules/agw.bicep' = {
  name: 'agw'
  params: {
    location: location
    prefix: prefix
    subnetId: vnet.outputs.agwSubnetId
  }
}

module vm 'modules/vm.bicep' = {
  name: 'vms'
  params: {
    location: location
    prefix: prefix
    adminUsername: adminUsername
    adminPassword: adminPassword    
    agwBackendPoolId: agw.outputs.backendPoolId
    subnetId: vnet.outputs.vmSubnetId
    vmSize: vmSize
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
