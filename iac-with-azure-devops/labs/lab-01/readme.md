# lab-01 - provision workshop support resources, get familiar and deploy workshop workload resources

## Goals

We need some support resources for this workshop and we need to implement and deploy workload infrastructure. 
The goal of this lab:
* create support resources
* get familiar with workload infrastructure implementation and deploy it to `dev` environment.

## Conventions

We use the following [conventions](../../conventions.md) for this workshop.

## Task #1 - create support resources Resource group and deploy Azure Key Vault

```powershell
# Create resource group for support resources
az group create -n iac-ado-ws1-rg -l norwayeast

# create Azure Key Vault
az keyvault create -g iac-ado-ws1-rg -n iac-ado-ws1-<some random string>-kv
```

## Task #2 - deploy workshop workload resources

We will manually deploy our workshop workload to `dev` environment

```powershell
# Goto iac folder
pwd
Path
----
<path to>\iac-workshops\iac-with-azure-devops\iac

# Create iac-ado-ws1-dev-rg resource group for dev environment
az group create -n iac-ado-ws1-dev-rg -l norwayeast

# Deploy to dev

```


## Useful links

* [az group create](https://learn.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-create)
* [az keyvault create](https://learn.microsoft.com/en-us/cli/azure/keyvault?view=azure-cli-latest#az-keyvault-create)

[Go to lab-02](../lab-02/readme.md)