# lab-02 - create Azure DNS Zone

You can use `Azure DNS` to host your DNS domain and manage your DNS records. By hosting your domains in Azure, you can manage your DNS records as code.

Suppose you buy the domain `iac-lab-wip.com` from a domain name registrar (in my case, I purchased it from [GoDaddy](GoDaddy.com)). You then create an Azure DNS Zone with the same name `iac-lab-wip.com` and since you're the owner of the domain, you can configure the name server (NS) records for your domain. Users around the world are then directed to your domain in your Azure DNS zone when they try to resolve DNS records in `iac-lab-wip.com`.

In this lab you will:

* implement DNS zone resource for your domain using Bicep
* migrate DNS records from registrar to Azure DNS Zone
* add new DNS records to Azure DNS Zone as code

> If you stack with implementation this lab, you can find complete solution in the `lab-02` folder of the `iac-lab-wip` repo.

## Task #1 - implement DNS zone

Create new file called YOU-DOMAIN-NAME.bicep under `modules` folder of your `iac-domains-iac` repo with the following content:

```bicep
param tags object
param dnsZoneContributors array

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'YOU-DOMAIN-NAME'
  location: 'global'
  tags: tags  
}

var dnsZoneContributorRoleId = 'befefa01-2a29-4197-83a8-272ff33ce314' // https://www.azadvertizer.net/azrolesadvertizer/befefa01-2a29-4197-83a8-272ff33ce314.html

resource administratorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for dnsZoneContributor in dnsZoneContributors: {
  scope: dnsZone
  name: guid(dnsZone.id, dnsZoneContributor, dnsZoneContributorRoleId)  
  properties: {
    principalId: dnsZoneContributor
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', dnsZoneContributorRoleId)
  }  
}]
```

> Note, the name of dnsZone resource must be exactly the same as your domain name. In my case, it's `iac-lab-wip.com` and the Bicep file name is `iac-lab-wip.com.bicep`.

There a parameter called `dnsZoneContributors` that will allow to assign `Dns Zone Contributor` role to the list of users or spns. For now it will be empty array, but later we will configure it.

Edit `parameters.json` file and add new parameter `dnsZoneContributors` with the following content:

```json
...
    "parameters": {
      ...
        "dnsZoneContributors": {
            "value": []
          }        
      ...
    }
...
```

Edit `deployment.bicep` file with the following content:

```bicep
targetScope = 'resourceGroup'

param workloadName string
param location string
param buildVersion string
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
```

Here we use `modules` feature of Bicep to import the DNS zone resource from the `modules\YOU-DOMAIN-NAME.bicep` file and we pass `tags` parameter to the module.

Commit changes to the `iac-domains-iac` repo.

```powershell
git status
git add -A
git commit -m "Add dnsZone resource"
git push
```

It will trigger the pipeline and deploy the changes to the `iac-domains-rg` environment. Check Azure DevOps `Pipelines`. You should have a new green release.

![1](images/1.png)

Check `Deployments` tab of the `iac-domains-rg` resource group and you should find new deployment with the same name as release name.

![2](images/2.png)

Check resources under `iac-domains-rg` resource group and you should find new DNS zone resource with the same name as your domain name.

![3](images/3.png)

## Task #2 - add Azure KeyVault for certificates

Create new `keyvault.bicep` file under `modules` folder with the following content:

```bicep
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
```

This file creates a new Azure KeyVault resource, assigns `Key Vault Administrator`, `Key Vault Certificate Officer` and `Key Vault Secrets User` roles to the specified identities configured with three parameters:
`keyvaultCertificatesOfficers`, `keyVaultAdministrators` and `keyVaultSecretsUsers`. 
Add three new parameters into the `parameters.json` file:

```json
...
    "parameters": {
      ...
        "keyvaultCertificatesOfficers": {
            "value": []
        },
        "keyVaultAdministrators": {
            "value": [
                "00000000-0000-0000-0000-000000000000" // az ad signed-in-user show --query id -o tsv
            ]
        },
        "keyVaultSecretsUsers": {
            "value": [
                "00000000-0000-0000-0000-000000000000"  // az ad sp show --id abfa0a7c-a6b6-4736-8310-5855508787cd  --query id -otsv
            ]
        }
        ...                
    }
...        
```

Replace `00000000-0000-0000-0000-000000000000` with your user object id under `keyVaultAdministrators` array. You get your user id with the following command:

```powershell
# Get signed in user id
az ad signed-in-user show --query id -o tsv
```

Add the `Microsoft.Azure.WebSites` service principal id into the `keyVaultSecretsUsers` array. You get the service principal id with the following command:

```powershell 
# get Microsoft.Azure.WebSites service principal id
az ad sp show --id abfa0a7c-a6b6-4736-8310-5855508787cd  --query id -otsv
```

We will add mode identities into this array.

Keep `keyvaultCertificatesOfficers` array empty, we will add more identities later.

Change the `deployment.bicep` file with the following content:

```bicep
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
```

and commit your changes.

```powershell
git status
git add -A
git commit -m "Add certificates KeyVault"
git push
```

The pipeline should start and deploy the changes to the `iac-domains-rg` Resource Group. Check Azure DevOps pipeline and `Deployment` tab of the `iac-domains-rg` resource group.
If pipeline is gree, you should now have a new Azure KeyVault and you should be assigned with `Key Vault Administrator` role. Check it under `Access control (IAM)` tab of the KeyVault.

![7](images/7.png)

## Task #3 - (optional) migrate DNS records from registrar to Azure DNS Zone

You should do this task only if you have DNS records in your domain registrar and you want them to be migrated.

### Export a zone file from registrar

At the registrar portal, go to `DNS Management` and export your DNS records to a file. I use GoDaddy. I navigated to `DNS Management` -> `iac-lab-wip.com` -> `DNS Records` and select `Export Zone file`.

![4](images/4.png)

In my case, records were exported into a file called `iac-lab-wip.com.txt`.

Check the content of this file and make sure that it contains only records you want to import. Change it if necessary.

### Import a zone file into Azure DNS Zone

You can't import records from the Azure portal. You need to use `az cli`. To import a zone file for your zone usee the following command:

```powershell
$domain = "YOU-DOMAIN-NAME"
$recordsFile = "path-to\exported-records-file.txt"
az network dns zone import -g iac-domains-rg -n $domain -f $recordsFile
```

## Task 4 - add new DNS records to Azure DNS Zone as code

Let's add new A-Record for `foobar` subdomain pointing to `10.10.0.1` IP address.

Open `iac-lab-wip.com.bicep` file and add the following resource:

```bicep
...
resource foobar 'Microsoft.Network/dnsZones/A@2018-05-01' = {
  name: 'foobar'
  parent: dnsZone
  properties: {
    TTL: 600
    ARecords: [
      {
        ipv4Address: '10.10.0.1'
      }
    ]
  }
}
```

Commit changes.

```powershell
git status
git add -A
git commit -m "Add foobar A-Record"
git push
```

This commit will trigger the pipeline and will deploy the changes to the your DNS Zone. Check Azure DevOps `Pipelines`. You should have a new green release.

![5](images/5.png)

Check you DNS Zone records at the portal. You should now have new A-Record for `foobar` subdomain.

![6](images/6.png)

## Useful links

* [Overview of DNS zones and records](https://docs.microsoft.com/en-us/azure/dns/dns-overview)
* [What is Azure DNS?](https://learn.microsoft.com/en-us/azure/dns/dns-overview)
* [az network dns zone](https://learn.microsoft.com/en-us/cli/azure/network/dns/zone?view=azure-cli-latest)

## Next

[Go to lab-03](../lab-03/readme.md)
