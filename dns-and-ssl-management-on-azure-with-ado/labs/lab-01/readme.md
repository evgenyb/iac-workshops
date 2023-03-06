# lab-01 - provision workshop infrastructure

As always, we start by provisioning the infrastructure for the workshop. In this lab, we will provision the following resources:

* Resource Group
* Azure Service Principal for IaC CI/CD pipeline
* New Azure DevOps repository for IaC code
* New Azure DevOps Service Connection for CI/CD pipeline
* New Azure DevOps pipeline for IaC deployment
* New Azure Key Vault for certificate management

To learn more about how to automate Azure workload provisioning, check my [Automate Azure workload provisioning with Bicep, Powershell and Azure DevOps workshop](https://github.com/evgenyb/iac-workshops/tree/main/iac-with-azure-devops). We will use the final script from this workshop to setup automated pipeline for IaC provisioning.

## Task #1 - provision support resources for the workshop

We will be using `Create-Workload.ps1` script that we created during the [Automate Azure workload provisioning with Bicep, Powershell and Azure DevOps workshop](https://github.com/evgenyb/iac-workshops/tree/main/iac-with-azure-devops) and it uses Azure Keyvault to store Azure Service Principal credentials. So, let's provision Azure Keyvault first. Since Azure Keyvault name has to be globally unique, we will use Bicep `uniqueString` function to generate a prt of Key Vault name. 

```powershell 
# Navigate to the iac folder
cd iac

# Deploy lab infrastructure
./deploy.ps1
```

This script will create the following resources:

* A new resource group called `iac-ws3-rg`
* A new Azure Key Vault called `iac-ws3-<unique-string>-kv`

In addition it will assign you a `Key Vault Administrator` role on the newly created Key Vault, so you can manage secrets.


## Task #2 - create new `domains-and-certificates` workload 

We will be using `Create-Workload.ps1` script that we created during the [Automate Azure workload provisioning with Bicep, Powershell and Azure DevOps workshop](https://github.com/evgenyb/iac-workshops/tree/main/iac-with-azure-devops) to create new workload called `domains-and-certificates`. 

You need to specify your Azure DevOps Organization url and Azure KeyVault name. You can get Azure KeyVault name from the previous step with this command.

```powershell
# Get Azure KeyVault name
az keyvault list -g iac-ws3-rg --query "[].name" -o tsv
```

Save `Create-Workload.ps1` file and run it with the following parameters:

```powershell
# Navigate to the iac folder 
cd iac

# Create new workload
./Create-Workload.ps1 -WorkloadName domains-and-certificates -CostCenter IaC -Owner 'James Bond' -Environment prod -DevOpsProject iac -Location norwayeast 
```

## Task #3 - configure Azure DevOps pipeline for IaC deployment


## Useful links


## Next
[Go to lab-02](../lab-02/readme.md)