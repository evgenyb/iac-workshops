param (
    [string]$DeploymentName
)

$workloadName = "keyvault-acmebot"
$workloadResourceGroup = "iac-$workloadName-rg"

Write-Host "[Deployment: $DeploymentName] - deploying $workloadName workload to $workloadResourceGroup resource group"
az deployment group create -g $workloadResourceGroup `
    -f src/deployment.bicep `
    -p src/parameters.json `
    -p buildVersion=$DeploymentName `
    -p workloadName=$workloadName `
    -n $DeploymentName