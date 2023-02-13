param location string
param kvName string
param vmAdminPasswordSecretName string
@secure()
param vmAdminPasswordSecretValue string 

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: kvName  
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: false
    enableRbacAuthorization: true
    softDeleteRetentionInDays: 7
    tenantId: subscription().tenantId
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: kv
  name: vmAdminPasswordSecretName
  properties: {
    value: vmAdminPasswordSecretValue
  }
}
