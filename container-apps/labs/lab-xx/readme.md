# lab-xx - cleaning up resources

This is the most important part of the workshop. We need to clean up all resources that we provisioned during the workshop to avoid unexpected bills.

## Task #1 - delete lab infrastructure

```powershell
# Remove all resources that were created during the workshop
az group delete --name iac-ws4-rg --yes
```
