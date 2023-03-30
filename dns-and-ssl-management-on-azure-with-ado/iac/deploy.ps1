$stopwatch = [System.Diagnostics.Stopwatch]::new()
$stopwatch.Start()
$location = 'norwayeast'

Write-Host "Get current user AAD object id..."
$signedUserId = (az ad signed-in-user show --query id -o tsv)

Write-Host "Deploying workshop lab infra into $location..."
az deployment sub create -l $location --template-file template.bicep -p location=$location -p signedInUserId=$signedUserId -n ws3-lab01

$stopwatch.Stop()

Write-Host "Deployment time: " $stopwatch.Elapsed 
