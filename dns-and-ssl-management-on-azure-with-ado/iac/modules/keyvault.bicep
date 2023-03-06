param prefix string
param location string
param signedInUserId string


var keyvaultName = '${prefix}-${uniqueString(subscription().subscriptionId, resourceGroup().id)}-kv'

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyvaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    enableSoftDelete: false
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    softDeleteRetentionInDays: 7
  }
}

var keyVaultAdministratorRoleId = '00482a5a-887f-4fb3-b363-3b7fe8e74483'

resource readersRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: kv
  name: guid(kv.id, signedInUserId, keyVaultAdministratorRoleId)  
  properties: {
    principalId: signedInUserId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyVaultAdministratorRoleId)
  }  
}
