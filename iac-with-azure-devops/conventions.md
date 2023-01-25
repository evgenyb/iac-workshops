# Conventions

For this workshop we use the following conventions:

* we call our workload `ado-ws1`
* workload will be deployed to `dev`, `test` and `prod` environments
* we will use resource group as a Bicep deployment scope, meaning that workload resource group should be created before we can deploy IaC code
* all workload resources are deployed to one Resource Group
* we use PowerShell script to orchestrate deployment
* we use the same Bicep implementation for all environments, the differences between environments are isolated into parameters file
* we use Azure DevOps repository to store IaC code
* we use branch-per-environment branching strategy
* we use Azure DevOps yaml based (not classic) pipeline for IaC deployment
 
## Naming conventions

### Azure and Azure AD Resources

| Resource type | Naming convention | Examples |
|--|--|--|
| Resource Group | iac-{workload-name}-{environment}-rg | iac-ado-ws1-dev-rg, iac-ado-ws1-test-rg, iac-ado-ws1-prod-rg |
| Resource Group for shared resources (without environment) | iac-{workload-name}-rg | iac-ado-ws1-rg |
| Azure KeyVault for shared resources (without environment) | iac-{workload-name}-kv | iac-ado-ws1-foobar-kv |
| Azure Virtual Network | iac-{workload-name}-{environment}-vnet | iac-ado-ws1-dev-vnet |
| Azure Virtual Network Subnet | {subnet name}-snet | workload-snet |

### Azure AD Resources

| Resource type | Naming convention | Examples |
|--|--|--|
| Workload Automation Service Principal | iac-{workload-name}-{environment}-iac-spn | iac-ado-ws1-dev-iac-spn, iac-ado-ws1-test-iac-spn, iac-ado-ws1-prod-iac-spn |

### Azure DevOps Resources

| Resource type | Naming convention | Examples |
|--|--|--|
| Azure DevOps Workload IaC Repository | iac-{workload-name}-iac | iac-ado-ws1-iac |
| Azure DevOps Workload Deployment Pipeline | iac-{workload-name}-iac | iac-ado-ws1-iac |
| Azure DevOps Service Connection | iac-{workload-name}-iac-{environment}-sc | iac-ado-ws1-iac-dev-sc, iac-ado-ws1-iac-test-sc, iac-ado-ws1-iac-prod-sc |


