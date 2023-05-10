$stopwatch = [System.Diagnostics.Stopwatch]::new()
$stopwatch.Start()

$location = 'norwayeast'
$deploymentName = 'iac-MGDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])

Write-Host "Deploying workshop lab infra into $location..."
az deployment sub create -l $location --template-file infra.bicep -p location=$location -n $deploymentName

$stopwatch.Stop()

Write-Host "Deployment time: " $stopwatch.Elapsed 
