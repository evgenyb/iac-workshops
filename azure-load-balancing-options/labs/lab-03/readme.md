# lab-03 - working with Azure Application Gateway

## AGW with VMs 

```powershell
$resourceGroupName = 'iac-ws2-lab03-rg'

# Create Resource Group
az group create -n $resourceGroupName -l norwayeast

# Deploy workload
az deployment group create -g $resourceGroupName --template-file template.bicep -n lab-03
```

> Deployment takes approx. 8 min.

## Links

https://learn.microsoft.com/en-us/azure/application-gateway/how-application-gateway-works

routing rules
https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-components#request-routing-rules
https://learn.microsoft.com/en-us/azure/application-gateway/url-route-overview

https://learn.microsoft.com/en-us/azure/application-gateway/quick-create-bicep?tabs=CLI

https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows
https://learn.microsoft.com/en-us/azure/application-gateway/quick-create-portal

## Next
[Go to lab-04](../lab-04/readme.md)