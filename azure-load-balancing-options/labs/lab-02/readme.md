# lab-02 - working with Azure Load Balancer

## Task #1 - create a public Azure Load Balancer to load balance two Virtual Machines using portal
## Task #2 - create a public Azure Load Balancer and Windows Virtual Machine Scale Set using Bicep

## AGW with VMs 

```powershell
$resourceGroupName = 'iac-ws2-lab02-rg'

# Create Resource Group
az group create -n $resourceGroupName -l norwayeast

# Deploy workload
az deployment group create -g $resourceGroupName --template-file template.bicep -n lab-02
```

> Deployment takes approx. 6 min.

## Links

https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-bicep?tabs=CLI
https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/quick-create-bicep-windows?tabs=CLI
https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-connect-to-instances-cli
https://learn.microsoft.com/en-us/azure/load-balancer/backend-pool-management

## Next
[Go to lab-03](../lab-03/readme.md)