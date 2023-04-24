targetScope = 'subscription'

param location string
@description('Two first segments of Virtual Network address prefix. For example, if the address prefix is 10.10.0.0/22, then the value of this parameter should be 10.10')
param vnetAddressPrefix string = '10.10'
@secure()
@description('Test VM admin account password.')
param testVMAdminPassword string

@description('Lab resources prefix.')
param prefix string = 'iac-ws4'

var resourceGroupName = '${prefix}-rg'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module la 'modules/logAnalytics.bicep' = {
  name: 'logAnalyticsWorkspace'
  scope: rg
  params: {
    location: location
    prefix: prefix
  }
}

module vnet 'modules/vnet.bicep' = {
  name: 'VirtualNetwork'
  scope: rg
  params: {
    location: location
    prefix: prefix
    vnetAddressPrefix: vnetAddressPrefix
  }
}

module bastion 'modules/bastion.bicep' = {
  name: 'bastion'
  scope: rg
  params: {
    location: location
    prefix: prefix
    bastionSubnetId: '${vnet.outputs.id}/subnets/AzureBastionSubnet'
  }
}

module acrPrivateDnsZone 'modules/acrPrivateDnsZone.bicep' = {
  name: 'acrPrivateDnsZone'
  scope: rg
  params: {
    linkedVNetId: vnet.outputs.id
  }  
}

module acr 'modules/acr.bicep' = {
  name: 'AzureContainerRegistry'
  scope: rg
  params: {
    location: location
    acrPrivateDnsZoneId: acrPrivateDnsZone.outputs.id
    privateLinkSubnetId: '${vnet.outputs.id}/subnets/plinks-snet'
  }
}

module testVM 'modules/devVM.bicep' = {
  name: 'testVM'
  scope: rg
  params: {
    location: location
    vmName: 'devVM'
    vmSubnetId: '${vnet.outputs.id}/subnets/testvm-snet'
    adminPassword: testVMAdminPassword
  }
}

module privateManagedEnv 'modules/private-menv.bicep' = {
  name: 'privateManagedEnv'
  scope: rg
  params: {
    location: location
    logAnalyticsName: la.outputs.name
    prefix: prefix
    subnetId: '${vnet.outputs.id}/subnets/capp-snet'
  }
}

module testApp 'modules/testapp.bicep' = {
  name: 'testApp'
  scope: rg
  params: {
    location: location
    environmentId: privateManagedEnv.outputs.environmentId
    prefix: prefix    
  }
}
var domains = []

module privateMenvPrivateDnsZone 'modules/acrPrivateDnsZone copy.bicep' = {
   name: 'privateMenvPrivateDnsZone'
   scope: rg
   params: {
     privateDnsZoneName: privateManagedEnv.outputs.defaultDomain
     linkedVNetId: vnet.outputs.id
     domainNames: concat(domains, [testApp.outputs.appName])
     staticIP: privateManagedEnv.outputs.staticIP
   }  
}
