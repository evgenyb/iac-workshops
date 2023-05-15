targetScope = 'subscription'

@description('Resources location')
param location string = 'norwayeast'

@description('Two first segments of Virtual Network address prefix. For example, if the address prefix is 10.10.0.0/22, then the value of this parameter should be 10.10')
param vnetAddressPrefix string = '10.10'

@description('Lab resources prefix.')
param prefix string = 'iac-ws4'

@description('Test VM admin username')
param testVMAdminUsername string = 'iac-admin'

@description('Test VM admin user password')
@secure()
param testVMAdminPassword string

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

module privateManagedEnv 'modules/private-cae.bicep' = {
  name: 'privateManagedEnv'
  scope: rg
  params: {
    location: location
    logAnalyticsName: la.outputs.name
    prefix: prefix
    subnetId: '${vnet.outputs.id}/subnets/capp-snet'
  }
}

module privateMenvPrivateDnsZone 'modules/privateMenvPrivateDnsZone.bicep' = {
  scope: rg
  name: 'privateMenvPrivateDnsZone'
   params: {
     privateDnsZoneName: privateManagedEnv.outputs.defaultDomain
     linkedVNetId: vnet.outputs.id
   }  
}

module publiManagedEnv 'modules/public-cae.bicep' = {
  name: 'publicManagedEnv'
  scope: rg
  params: {
    location: location
    logAnalyticsName: la.outputs.name
    prefix: prefix
  }
}


var uniqueStr = uniqueString(subscription().subscriptionId, rg.id)
var acrName = 'iacws4${uniqueStr}acr'

module acr 'modules/acr.bicep' = {
  name: 'AzureContainerRegistry'
  scope: rg
  params: {
    acrName: acrName 
    location: location
  }
}

module appInsights 'modules/appInsights.bicep' = {
  scope: rg
  name: 'appInsights'
  params: {
    location: location
    prefix: prefix
    workspaceId: la.outputs.id
  }
}

module sql 'modules/cosmosdb.bicep' = {
  scope: rg
  name: 'cosmosdb'
  params: {
    location: location
    prefix: prefix
  }
}

module bastion 'modules/bastion.bicep' = {
  scope: rg
  name: 'bastion'
  params: {
    location: location
    prefix: prefix
    subnetId: '${vnet.outputs.id}/subnets/AzureBastionSubnet'
  }
}

module testVM 'modules/testVM.bicep' = {
  scope: rg
  name: 'testVM'
  params: {
    location: location
    vmName: 'testVM'
    vmSubnetId: '${vnet.outputs.id}/subnets/testvm-snet'
    adminUsername: testVMAdminUsername
    adminPassword: testVMAdminPassword
  }
}
