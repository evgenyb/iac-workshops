targetScope = 'resourceGroup'

param workloadName string
param location string
param buildVersion string
param mailAddress string
param logAnalyticsWorkspaceResourceId string
param dnsProviderConfiguration array
param keyVaultBaseUrl string

param tags object = {
  BuildVersion: buildVersion
  WorkloadName: workloadName
}

module acmebot 'modules/keyvault-acmebot.bicep' = {
  name: 'acmebot'
  params: {
    appNamePrefix: 'iac'
    mailAddress: mailAddress
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    location: location
    createWithKeyVault: false
    createWithLogAnalytics: false
    dnsProviderConfiguration: dnsProviderConfiguration
    keyVaultBaseUrl: keyVaultBaseUrl
  } 
}
