# lab-06 - cleaning up resources

This is the most important part of the workshop. We need to clean up all resources that we provisioned during the workshop. This is important because we don't want to pay for resources that we don't use.

## Task #1 - delete lab infrastructure

```powershell
# Delete iac-ws3-rg resource group
az group delete --name iac-ws3-rg --yes --no-wait

# Delete iac-domains-rg resource group
az group delete --name iac-domains-rg --yes --no-wait

# Delete iac-keyvault-acmebot-rg resource group
az group delete --name iac-keyvault-acmebot-rg --yes --no-wait
```
