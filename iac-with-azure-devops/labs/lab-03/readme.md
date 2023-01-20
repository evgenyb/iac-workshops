# lab-03 - working with Azure DevOps Service Connections

Azure DevOps Service Connections help you manage, protect, and reuse authentications to external services. There are [different types](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml#common-service-connection-types) of Service Connections available, but we will work with one called `Azure Resource Manager service connection`. 

In this lab you will learn:

* how to create new Azure Resource Manager service connection from Azure Devops portal
* how to create new Azure Resource Manager service connection using `az devops` extension
* how to create new Azure Resource Manager service connection using `Azure DevOps REST API` 

## Prerequisites


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
$spnName = 'iac-lab1-task4-spn'
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

## Useful links

* [Manage service connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml)
* [Common service connection types](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml#common-service-connection-types)
* [Azure Resource Manager service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml#azure-resource-manager-service-connection)