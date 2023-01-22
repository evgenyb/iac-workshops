param (
    [string]$Environment,
    [string]$DeploymentName
)

$workloadName = "ado-ws1"
$workloadResourceGroup = "iac-$workloadName-$Environment-rg"

Write-Host "[Deployment: $DeploymentName] - deploying $workloadName workload to $workloadResourceGroup resource group"
az deployment group create -g $workloadResourceGroup `
    -f src/deployment.bicep `
    -p src/parameters-$Environment.json `
    -p buildVersion=$DeploymentName `
    -p workloadName=$workloadName `
    -p environment=$Environment `
    -n $DeploymentName