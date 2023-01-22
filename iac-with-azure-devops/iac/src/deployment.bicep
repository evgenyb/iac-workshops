targetScope = 'resourceGroup'

param workloadName string
param location string
param environment string
param vnetConfig object
param buildVersion string

param tags object = {
  BuildVersion: buildVersion
}

module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    workloadName: workloadName
    environment: environment
    vnetConfig: vnetConfig
    tags: tags
  }
}
