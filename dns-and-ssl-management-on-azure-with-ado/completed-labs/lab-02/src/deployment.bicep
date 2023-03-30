targetScope = 'resourceGroup'

param workloadName string
param location string
param buildVersion string
param keyvaultCertificatesOfficers array
param keyVaultAdministrators array
param keyVaultSecretsUsers array
param dnsZoneContributors array

param tags object = {
  BuildVersion: buildVersion
  WorkloadName: workloadName
}

module dnsZone 'modules/YOU-DOMAIN-NAME.bicep' = {
  name: 'YOU-DOMAIN-NAME'
  params: {
    tags: tags
    dnsZoneContributors: dnsZoneContributors
  }
}

module kv 'modules/keyvault.bicep' = {
  name: 'certificates-keyvault'
  params: {
    location: location
    keyVaultAdministrators: keyVaultAdministrators
    keyvaultCertificatesOfficers: keyvaultCertificatesOfficers
    keyVaultSecretsUsers: keyVaultSecretsUsers
    tags: tags
  }
}
