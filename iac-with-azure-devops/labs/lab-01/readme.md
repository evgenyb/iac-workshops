# lab-01 - provision workshop resources and get familiar with IaC code

## Goals

We need some support resources for this workshop and the goal of this lab is to create them. 

## Task #1 - create Azure Resource group and Azure Key Vault

```powershell
# Create resource group for support resources
az group create -n iac-devops-ws1-support-rg -l norwayeast

# create Azure Key Vault
az keyvault create -g iac-devops-ws1-support-rg -n iac-devops-ws1-<some random string>-kv
```


## Useful links

* [az group create](https://learn.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-create)
* [az keyvault create](https://learn.microsoft.com/en-us/cli/azure/keyvault?view=azure-cli-latest#az-keyvault-create)

[Go to lab-02](../lab-02/readme.md)