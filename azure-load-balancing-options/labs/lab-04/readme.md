# lab-04 - working with Azure Traffic Manager

## AGW with VMs 

```powershell
$resourceGroupName = 'iac-ws2-lab04-rg'

# Create Resource Group
az group create -n $resourceGroupName -l norwayeast

# Deploy workload
az deployment group create -g $resourceGroupName --template-file template.bicep -n lab-04
```

> Deployment takes approx. xx min.

## Links

* [What is Traffic Manager?](https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview)
* [Tutorial: Improve website response using Traffic Manager](https://learn.microsoft.com/en-us/azure/traffic-manager/tutorial-traffic-manager-improve-website-response)

## Next
[Go to lab-05](../lab-05/readme.md)