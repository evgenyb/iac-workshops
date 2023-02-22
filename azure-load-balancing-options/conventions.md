# Conventions

For this workshop we use the following conventions:

* we use `iac` as a prefix for all resources
* we call our workload `ws2`
* workload will be deployed to `norwayeast` and `eastus` regions
* we will use Subscription as a Bicep deployment scope
 
## Naming conventions

### Azure and Azure AD Resources

| Resource type | Naming convention | Examples |
|--|--|--|
| Resource Group | {prefix}-{workload-name}-{location}-rg | iac-ws2-norwayeast-rg, iac-ws2-eastus-rg |
| Resource Group for shared resources (without location) | {prefix}-{workload-name}-rg | iac-ws2-rg |
| Azure KeyVault for shared resources (without location) | {prefix}-{workload-name}-kv | iac-ws2-foobar-kv |
| Application Gateway (without location) | {prefix}-{workload-name}-agw | iac-ws2-agw |
| Azure Virtual Network | {prefix}-{workload-name}-{location}-vnet | iac-ws2-norwayeast-vnet |
| Azure Virtual Network Subnet | {subnet name}-snet | workload-snet |
| Azure Load Balancer | {prefix}-{workload-name}-{location}-alb | iac-ws2-norwayeast-alb |
| Public IP | {prefix}-{workload-name}-{parent_resource_name}-pip | iac-ws2-norwayeast-alb-pip |
| Azure Bastion | {prefix}-{workload-name}-bastion | iac-ws2-bastion |


