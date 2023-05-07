targetScope = 'subscription'

@description('Resources location')
param location string = 'westeurope'

@description('Two first segments of Virtual Network address prefix. For example, if the address prefix is 10.10.0.0/22, then the value of this parameter should be 10.10')
param vnetAddressPrefix string = '10.10'

@description('Lab resources prefix.')
param prefix string = 'iac-ws4'

var tenantId = tenant().tenantId

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

module acrPrivateDnsZone 'modules/acrPrivateDnsZone.bicep' = {
  name: 'acrPrivateDnsZone'
  scope: rg
  params: {
    linkedVNetId: vnet.outputs.id
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

var uniqueStr = uniqueString(subscription().subscriptionId, rg.id)
var acrName = 'iacws4${uniqueStr}acr'

module acr 'modules/acr.bicep' = {
  name: 'AzureContainerRegistry'
  scope: rg
  params: {
    acrName: acrName 
    location: location
    acrPrivateDnsZoneId: acrPrivateDnsZone.outputs.id
    privateLinkSubnetId: '${vnet.outputs.id}/subnets/plinks-snet'
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

module privateMenvPrivateDnsZone 'modules/privateMenvPrivateDnsZone.bicep' = {
  scope: rg
  name: 'privateMenvPrivateDnsZone'
   params: {
     privateDnsZoneName: privateManagedEnv.outputs.defaultDomain
     linkedVNetId: vnet.outputs.id
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
    linkedVNetId: vnet.outputs.id
    privateLinkSubnetId: '${vnet.outputs.id}/subnets/plinks-snet'
  }
}
