targetScope = 'resourceGroup'

param location string = resourceGroup().location
param keyvaultCertificatesOfficers array
param keyVaultAdministrators array
param keyVaultSecretsUsers array
param tags object

var kvName = 'iac-${uniqueString(subscription().id, resourceGroup().name)}-kv'
resource kv 'Microsoft.KeyVault/vaults@2022-11-01' = {
  name: kvName
  location: location
  tags: tags
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

var keyVaultAdministratorRoleId = '00482a5a-887f-4fb3-b363-3b7fe8e74483' // https://www.azadvertizer.net/azrolesadvertizer/00482a5a-887f-4fb3-b363-3b7fe8e74483.html

resource administratorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for keyVaultAdministrator in keyVaultAdministrators: {
  scope: kv
  name: guid(kv.id, keyVaultAdministrator, keyVaultAdministratorRoleId)  
  properties: {
    principalId: keyVaultAdministrator
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyVaultAdministratorRoleId)
  }  
}]

var keyvaultCertificatesOfficerRoleId = 'a4417e6f-fecd-4de8-b567-7b0420556985' // https://www.azadvertizer.net/azrolesadvertizer/a4417e6f-fecd-4de8-b567-7b0420556985.html
resource certificatesOfficerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for officer in keyvaultCertificatesOfficers: {
  scope: kv
  name: guid(kv.id, officer, keyvaultCertificatesOfficerRoleId)  
  properties: {
    principalId: officer
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyvaultCertificatesOfficerRoleId)
  }  
}]

var keyvaultsecretsUserRoleId = '4633458b-17de-408a-b874-0445c86b69e6' // https://www.azadvertizer.net/azrolesadvertizer/4633458b-17de-408a-b874-0445c86b69e6.html
resource secretsUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for secretsUser in keyVaultSecretsUsers: {
  scope: kv
  name: guid(kv.id, secretsUser, keyvaultsecretsUserRoleId)  
  properties: {
    principalId: secretsUser
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyvaultsecretsUserRoleId)
  }  
}]

output keyVaultName string = kv.name
output keyVaultId string = kv.id
