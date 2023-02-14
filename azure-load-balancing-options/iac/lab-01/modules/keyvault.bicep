param location string
param kvName string
param vmAdminPasswordSecretName string
@secure()
param vmAdminPasswordSecretValue string 
param signedInUserId string

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

var keyVaultAdministratorRoleId = '00482a5a-887f-4fb3-b363-3b7fe8e74483'

resource readersRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: kv
  name: guid(kv.id, signedInUserId, keyVaultAdministratorRoleId)  
  properties: {
    principalId: signedInUserId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyVaultAdministratorRoleId)
  }  
}
