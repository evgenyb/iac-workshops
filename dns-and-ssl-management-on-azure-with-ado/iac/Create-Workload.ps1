<#
.SYNOPSIS
    Master script that creates new Azure Workload based on the convention 
.EXAMPLE
    ./Create-Workload.ps1 -WorkloadName foobar -CostCenter Dev -Owner 'James Bond' -DevOpsProject iac -Location norwayeast -DevOpsRepositoryDefaultBranch master
#>
[CmdletBinding()]
param (
    # Workload name
    [Parameter(Mandatory = $true)]
    [String]$WorkloadName,
    # Workload environment 
    # CostCenter that owns the workload. 
    [Parameter(Mandatory = $true)]
    [ValidateSet('IaC', 'IT','Dev','3000')]
    [String]$CostCenter,
    # Workload owner
    [Parameter(Mandatory = $true)]
    [String]$Owner,
    # Worklaod Location. Default is "Norway East"
    [Parameter(Mandatory = $false)]
    [String]$Location = "norwayeast",
    # Azure DevOps Project name
    [Parameter(Mandatory = $true)]
    [String]$DevOpsProject,
    [Parameter(Mandatory = $false)]
    [String]$DevOpsRepositoryDefaultBranch = "main"
)
process {
    $prefix = "iac"
    $azureDevOpsOrganization = "YOUR-ADO-ORG-URL"
    $spnMetadataKeyvaultName = "YOUR-KEY-VAULT"

    $userName = (az account show --query user.name -o tsv)
    $tenantId = (az account show --query tenantId -o tsv)
    $subscriptionId = $(az account show --query id -o tsv)
    $subscriptionName = (az account subscription show --subscription-id $subscriptionId --query displayName -otsv)
    Write-Host "Current subscription is $subscriptionId ($subscriptionName)"

    $userObjectId = (az ad signed-in-user show --query id --only-show-errors -o tsv)
    
    Write-Host "Checking Azure roles assignment for assignee '$userName' ($userObjectId)..."
    $assignedRoles = (az role assignment list --all --assignee $userObjectId --query [].roleDefinitionName -o json --only-show-errors | ConvertFrom-Json)
    
    if ((-Not $assignedRoles.Contains('Contributor')) -or (-Not $assignedRoles.Contains('User Access Administrator'))) {
        Write-Host "You must have 'Contributor' and 'User Access Administrator' roles at the '$subscriptionName' ($subscriptionId) subscription."
        exit 
    }

    $resourceGroupName = "$prefix-$WorkloadName-rg"
    $spnName = "$prefix-$WorkloadName-iac-spn"
    $serviceConnectionName = "$prefix-$WorkloadName-iac-sc"
    $repoName = "$prefix-$WorkloadName-iac"
    $pipelineName = "$prefix-$WorkloadName-iac"

    Write-Host "Creating new resource group $resourceGroupName under $subscriptionName ($subscriptionId) subscription in $Location region"
    az group create --subscription $subscriptionId -n $resourceGroupName -l $Location --tags "WorkloadName=$WorkloadName" "CostCenter=$CostCenter" "Owner=$Owner" --only-show-errors --output none 

    Write-Host "Check if SPN $spnName already exists"
    $spnObjectId = (az ad sp list --filter "displayName eq '$spnName'" --query [].id -otsv)
    if (-Not $spnObjectId) {
        Write-Host "Creating new Azure AD Service Principal $spnName"
        $spnMetadata = (az ad sp create-for-rbac -n $spnName --years 99 --only-show-errors -o json | ConvertFrom-Json)    
        $clientId = $spnMetadata.appId
        $clientSecret = $spnMetadata.password
    
        Write-Host "Get $spnName ObjectId..."
        $spnObjectId = (az ad sp show --id $clientId --query id -otsv)
    
        Write-Host "Storing $spnName client id, client secret and tenant id into the $spnMetadataKeyvaultName Key Vault:"
        $spnClientIdSecretName = "$spnName-client-id"        
        Write-Host "    client id -> $spnClientIdSecretName"
        az keyvault secret set --output none `
            -n $spnClientIdSecretName `
            --value $clientId `
            --description "$spnName client id" `
            --vault-name $spnMetadataKeyvaultName 

        $spnClientSecretSecretName = "$spnName-client-secret"
        Write-Host "    client secret -> $spnClientSecretSecretName"
        az keyvault secret set --output none `
            -n $spnClientSecretSecretName `
            --value $clientSecret `
            --description "$spnName client secret" `
            --vault-name $spnMetadataKeyvaultName 

        $spnClientTenantIdSecretName = "$spnName-tenant-id"
        Write-Host "    tenant-id -> $spnClientTenantIdSecretName"
        az keyvault secret set --output none `
            -n $spnClientTenantIdSecretName `
            --value $tenantId `
            --description "$spnName tenant id" `
            --vault-name $spnMetadataKeyvaultName 

        Write-Host "Assigning Owner role to SPN $spnName ($clientId) at $resourceGroupName scope"
        az role assignment create --assignee $clientId -g $resourceGroupName --subscription $subscriptionId --role Owner --only-show-errors --output none

        Write-Host "Creating new Azure DevOps Service Connection $serviceConnectionName in $DevOpsProject project under $azureDevOpsOrganization organization"
        $env:AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY = $clientSecret
    
        az devops service-endpoint azurerm create `
            --azure-rm-service-principal-id $clientId `
            --azure-rm-subscription-id $subscriptionId `
            --azure-rm-subscription-name $subscriptionName `
            --azure-rm-tenant-id $tenantId `
            --name $serviceConnectionName `
            --organization $azureDevOpsOrganization `
            --project $DevOpsProject `
            --only-show-errors --output none
    } 
    else {
        Write-Host "$spnName already exists. Do nothing..."
    }
    
    Write-Host "Check if repository $repoName already exists at $DevOpsProject project under $azureDevOpsOrganization organization"
    $repo = (az repos show `
            --repository $repoName `
            --organization $azureDevOpsOrganization `
            --project $DevOpsProject `
            --only-show-errors -o json | ConvertFrom-Json)
    
    if ($repo) {
        Write-Host "Repository $repoName already exists. Do nothing..."
    } else {
        Write-Host "Creating new $repoName repository at $DevOpsProject project under $azureDevOpsOrganization organization"

        az repos create `
            --name $repoName `
            --organization $azureDevOpsOrganization `
            --project $DevOpsProject `
            --only-show-errors --output none    
    }        
    
    Write-Host "Check if pipeline $pipelineName already exists at $DevOpsProject project under $azureDevOpsOrganization organization"
    $pipeline = (az pipelines show `
            --name $pipelineName `
            --organization $azureDevOpsOrganization `
            --project $DevOpsProject `
            --only-show-errors -o json | ConvertFrom-Json)
    
    if ($pipeline) {
        Write-Host "Pipeline $pipelineName already exists. Do nothing..."
    } else {
        Write-Host "Creating pipeline $pipelineName under the $DevOpsProject project"
        az pipelines create `
            --name $pipelineName `
            --description 'Pipeline for Workload IaC deployment' `
            --repository $repoName `
            --branch $DevOpsRepositoryDefaultBranch `
            --repository-type tfsgit `
            --folder-path IaC `
            --yaml-path azure-pipelines.yaml `
            --organization $azureDevOpsOrganization `
            --skip-first-run true `
            --project $DevOpsProject `
            --only-show-errors --output none    
    }    
}
end {
}
