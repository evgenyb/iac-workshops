# lab-03 - working with Azure DevOps Service Connections

Azure DevOps Service Connections help you manage, protect, and reuse authentications to external services. There are [different types](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml#common-service-connection-types) of Service Connections available, but we will work with one called `Azure Resource Manager service connection`. 

In this lab you will learn:

* how to create new Azure Resource Manager service connection from Azure Devops portal
* how to create new Azure Resource Manager service connection using `az devops` extension


## Task #1 - create new Azure Resource Manager service connection at Azure Devops portal

Complete the following steps to create a service connection.

* Sign in to your organization (https://dev.azure.com/{yourorganization}) and select your project
* Select `Project settings > Service connections`
* Select  `+ New service connection` or `Create service connection` if you don't have any service connections yet. 

![image](images/task1-1.jpg)

* Select `Azure Resource Manager` as service connection type 

![image](images/task1-2.jpg)

and select `Next` (you need to scroll all the way down)

![image](images/task1-3.jpg)

Select `Service principal (manual)` and click `Next`

![image](images/task1-4.jpg)

We need the following information to fulfill registration:

* Subscription ID
* Subscription Name
* Service Principal Id
* Service principal key
* Tenant ID

Let's collect this information. During `lab-01`, we already created `Azure Service Principal` and stored its credentials into Azure KeyVault, so let's use it.  

```powershell
# Get Subscription ID
$subscriptionID = (az account show --query id -otsv)

# Get Subscription Name
$subscriptionName = (az account show --query name -otsv)

# Get SPN credentials from Azure KeyVault
$spnName = 'iac-ado-ws1-dev-iac-spn'
$spnMetadataKeyvaultName = '<Azure Key Vault Name you used at lab-01>'

$servicePrincipalID = (az keyvault secret show -n "$spnName-client-id" --vault-name $spnMetadataKeyvaultName --query value -otsv)
$servicePrincipalKey = (az keyvault secret show -n "$spnName-secret" --vault-name $spnMetadataKeyvaultName --query value -otsv)
$tenantID = (az keyvault secret show -n "$spnName-tenant-id" --vault-name $spnMetadataKeyvaultName --query value -otsv)


Write-Host "Subscription ID: $subscriptionID`
Subscription Name: $subscriptionName`
Service principal Id: $servicePrincipalID`
Service principal key: $servicePrincipalKey` 
Tenant ID: $tenantID"
```

THis script should output all 5 values and output should look like one I got:

```powershell
Subscription ID: 00000000-0000-0000-0000-000000000000
Subscription Name: Microsoft Azure Sponsorship
Service principal Id: 00000000-0000-0000-0000-000000000000
Service principal key: NXv8Q~FaTDLEssasazDrJ4i5Z5.tDKi3bnstBKxn7nad8
Tenant ID: 00000000-0000-0000-0000-000000000000
```

Now use these values and fulfill the `New Azure service connection` form:

![image](images/task1-5.jpg)

Note that you should: 
* select `Azure Cloud` as an Environment (unless you are not using `Azure China Cloud` or `Azure German Cloud`)
* select Scope level `Subscription`
* Credential as `Service principal key`

When set all values, click `Verify` and if everything is set correctly, you should get `Verification Succeeded`.

Then give the Service Connection a name and `Save` it

![image](images/task1-6.jpg)


## Task #2 - create new Azure Resource Manager service connection with `az devops`

### Install `az devops` extension 

The Azure DevOps Extension for Azure CLI adds Pipelines, Boards, Repos, Artifacts and DevOps commands to the Azure CLI 2.0.

Before you can start using `az devops` extension, make sure that your `az cli` is at least at version `v2.0.69`

```powershell
# Check az cli version
az --version
azure-cli                         2.43.0 *

# Install az devops extension
az extension add --name azure-devops
```

If your Azure DevOps organization is connected to Azure AD directory, then you don't need to authenticate towards Azure DevOps, else you need to generate [Azure DevOps Personal Access Token (PAT)](https://learn.microsoft.com/en-gb/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows#create-a-pat) and use it to login with `az devops login` command.

```powershell
# try to get Azure DevOps projects
az devops project list
Before you can run Azure DevOps commands, you need to run the login command(az login if using AAD/MSA identity else az devops login if using PAT token) to setup credentials.  Please see https://aka.ms/azure-devops-cli-auth for more information.

# Login to 
az devops login
Token:

# Set default organization
az devops configure -d organization=https://dev.azure.com/your_ortganization

# Alternatively, you can use --org flag and send organization url as part of request

# Get Azure DevOps projects
az devops project list --query value[].name

# Get Azure DevOps projects for specified organization
az devops project list --org https://dev.azure.com/your_ortganization --query value[].name
```

###  Create Service connection

To create `Azure Resource Manager service connection` we will use [az devops service-endpoint azurerm](https://learn.microsoft.com/en-us/cli/azure/devops/service-endpoint/azurerm?WT.mc_id=AZ-MVP-5003837&view=azure-cli-latest) command. This command requires the following parameters:

* azure-rm-service-principal-id
* azure-rm-subscription-id
* azure-rm-subscription-name
* azure-rm-tenant-id

and for automation, it requires to set service principal password/secret in `AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY` environment variable. 

As you can see, it requires the same information we used when we created New Service Connection at the Azure DevOps portal, if you are working at the same PowerShell session, then these variables are still available and we can re-use them, if not, re-run PowerShell script we used at `Task #1`.


```powershell
# Set AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY environment variable
$env:AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY = $servicePrincipalKey

az devops service-endpoint azurerm create `
    --azure-rm-service-principal-id $servicePrincipalID `
    --azure-rm-subscription-id $subscriptionID `
    --azure-rm-subscription-name $subscriptionName `
    --azure-rm-tenant-id $tenantId `
    --name 'iac-ado-ws1-iac-dev-sc' `
    --project 'iac' 

# Get list of available service connections
az devops service-endpoint list --project iac --query [].name
[
  "iac-test-cs",
  "iac-ado-ws1-iac-dev-sc"
]
```

## Useful links

* [Manage service connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml)
* [Common service connection types](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml#common-service-connection-types)
* [Azure Resource Manager service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml#azure-resource-manager-service-connection)
* [az devops service-endpoint azurerm](https://learn.microsoft.com/en-us/cli/azure/devops/service-endpoint/azurerm?WT.mc_id=AZ-MVP-5003837&view=azure-cli-latest)
* [Create Azure DevOps Personal Access Token (PAT)](https://learn.microsoft.com/en-gb/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows#create-a-pat)

## Next
[Go to lab-04](../lab-04/readme.md)