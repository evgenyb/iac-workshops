# lab-04 - working with Azure Front Door

Azure Front Door is a fully managed, high-performance web application accelerator that provides global load balancing, multi-site origin hosting, and end-to-end HTTP/HTTPS.

We will be using Azure Virtual MAchines as Front Door Origins

As with Azure Traffic Manager, we will use Azure CLI to create Azure Front Door.

## Task #1 - create Azure Front Door profile, origin and endpoint

Run [az afd profile create](https://learn.microsoft.com/en-us/cli/azure/afd/profile?view=azure-cli-latest#az-afd-profile-create) to create an Azure Front Door profile.

```powershell
# Create a Front Door profile
az afd profile create --profile-name iac-ws2-fd --resource-group iac-ws2-rg --sku Standard_AzureFrontDoor
```

Next, we'll create an endpoint - a logical grouping of one or more routes that are associated with domain names. 

```powershell	
# Create a Front Door endpoint
az afd endpoint create --endpoint-name iac-ws2-fd-endpoint --profile-name iac-ws2-fd --resource-group iac-ws2-rg --origin-host-header iac-ws2-fd.azurefd.net --origin-response-timeout-seconds 60 --origin-path / --origin iac-ws2-fd.azurefd.net --custom-domain iac-ws2-fd.azurefd.net --enable-https true --https-only true --query customHttpsProvisioningState
```

## Lowest latencies based traffic-routing method

## Priority-based traffic-routing method

## Weighted traffic-routing method


## Links

* [What is Azure Front Door?](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview)
* [Azure Front Door edge locations by metro](https://learn.microsoft.com/en-us/azure/frontdoor/edge-locations-by-region)
* [Quickstart: Create an Azure Front Door Standard/Premium - Azure CLI](https://learn.microsoft.com/en-us/azure/frontdoor/create-front-door-cli)
* [Traffic routing methods to origin](https://learn.microsoft.com/en-us/azure/frontdoor/routing-methods)
* [Routing architecture overview](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-routing-architecture?pivots=front-door-standard-premium)
* [Solution architecture](https://learn.microsoft.com/en-us/azure/frontdoor/scenarios#solution-architecture)
* [Overall decision flow](https://learn.microsoft.com/en-us/azure/frontdoor/routing-methods#overall-decision-flow)
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/afd?view=azure-cli-latest)

## Next
[Go to lab-06](../lab-06/readme.md)