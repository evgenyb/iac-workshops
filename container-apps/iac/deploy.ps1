$stopwatch = [System.Diagnostics.Stopwatch]::new()
$stopwatch.Start()

$location = 'westeurope'

Write-Host "Deploying workshop lab infra into $location..."
az deployment sub create -l $location --template-file template.bicep -p location=$location -n deployment-123

$stopwatch.Stop()

Write-Host "Deployment time: " $stopwatch.Elapsed 
