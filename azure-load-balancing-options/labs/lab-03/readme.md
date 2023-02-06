
## AGW with VMs 

```powershell
$resourceGroupName = 'iac-ws2-lab03-rg'

# Create Resource Group
az group create -n $resourceGroupName -l norwayeast

# Deploy workload
az deployment group create -g $resourceGroupName --template-file template.bicep -n deployment-from-my-pc
```