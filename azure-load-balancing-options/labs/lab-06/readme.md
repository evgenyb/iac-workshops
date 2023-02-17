# lab-06 - cleaning up resources

This is the most important part of the workshop. We need to clean up all resources that we provisioned during the workshop. 

## Task #1 - delete lab infrastructure

```powershell	
# Delete iac-ws2-rg resource group
az group delete --name iac-ws2-rg --yes --no-wait

# Delete iac-ws2-norwayeast-rg resource group
az group delete --name iac-ws2-norwayeast-rg --yes --no-wait

# Delete iac-ws2-eastus-rg resource group
az group delete --name iac-ws2-eastus-rg --yes --no-wait
```
