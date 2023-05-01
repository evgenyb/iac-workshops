targetScope = 'subscription'

param location string
@description('Two first segments of Virtual Network address prefix. For example, if the address prefix is 10.10.0.0/22, then the value of this parameter should be 10.10')
param vnetAddressPrefix string = '10.10'
// @secure()
// @description('Test VM admin account password.')
// param testVMAdminPassword string

@description('Lab resources prefix.')
param prefix string = 'iac-ws4'

@secure()
param tenantId string = tenant().tenantId

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

// module bastion 'modules/bastion.bicep' = {
//   name: 'bastion'
//   scope: rg
//   params: {
//     location: location
//     prefix: prefix
//     bastionSubnetId: '${vnet.outputs.id}/subnets/AzureBastionSubnet'
//   }
// }

module acrPrivateDnsZone 'modules/acrPrivateDnsZone.bicep' = {
  name: 'acrPrivateDnsZone'
  scope: rg
  params: {
    linkedVNetId: vnet.outputs.id
  }  
}



// module testVM 'modules/testVM.bicep' = {
//   name: 'testVM'
//   scope: rg
//   params: {
//     location: location
//     vmName: 'testVM'
//     vmSubnetId: '${vnet.outputs.id}/subnets/testvm-snet'
//     adminPassword: testVMAdminPassword
//   }
// }

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

var uniqueStr = uniqueString(subscription().subscriptionId, rg.id)
var acrName = 'iacws4${uniqueStr}acr'

var testAppName = '${prefix}-test-capp'
module testAppManagedIdentity 'modules/mi.bicep' = {
  name: 'testAppMI'
  scope: rg
  params: {
    location: location
    miName: '${testAppName}-mi'
  }
}

var acrPullObjectsIds = []
module acr 'modules/acr.bicep' = {
  name: 'AzureContainerRegistry'
  scope: rg
  params: {
    acrName: acrName 
    location: location
    acrPrivateDnsZoneId: acrPrivateDnsZone.outputs.id
    privateLinkSubnetId: '${vnet.outputs.id}/subnets/plinks-snet'
    acrPullObjectsIds: concat(acrPullObjectsIds, [testAppManagedIdentity.outputs.principalId])
  }
}

module testApp 'modules/testapp.bicep' = {
  name: testAppName
  scope: rg
  params: {
    appName: testAppName
    acrName: acr.outputs.acrName
    location: location
    environmentId: privateManagedEnv.outputs.environmentId
    managedIdentity: testAppManagedIdentity.outputs.id
  }
}

var domains = []

module privateMenvPrivateDnsZone 'modules/privateMenvPrivateDnsZone.bicep' = {
   name: 'privateMenvPrivateDnsZone'
   scope: rg
   params: {
     privateDnsZoneName: privateManagedEnv.outputs.defaultDomain
     linkedVNetId: vnet.outputs.id
     domainNames: concat(domains, [testAppName])
     staticIP: privateManagedEnv.outputs.staticIP
   }  
}

module vpnGateway 'modules/vpnGateway.bicep' = {
  scope: rg
  name: 'vpnGateway'
  params: {
    gatewaySubnetId: '${vnet.outputs.id}/subnets/GatewaySubnet'
    location: location
    prefix: prefix
    tenantId: tenantId
  }
}


module dnsResolver 'modules/dnsResolver.bicep' = {
  scope: rg
  name: 'dnsResolver'
  params: {
    location: location
    prefix: prefix
    subnetId: '${vnet.outputs.id}/subnets/dnsresolver-inbound-snet'
    vnetId: vnet.outputs.id
  }
}
