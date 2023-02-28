# Get Traffic Manager profile URL
$weightedTrafficManagerUrl = (az network traffic-manager profile show --name iac-ws2-weighted-tfm --resource-group iac-ws2-rg --query dnsConfig.fqdn -otsv)

$noCount = 0
$usCount = 0
$i = 0
while ($true) { 
    $response = (curl http://$weightedTrafficManagerUrl --silent) 
    if($response -contains "lab04-vm-no-0") { 
        $noCount++ 
    } elseif ($response -contains "lab04-vm-us-0") { 
        $usCount++         
    }
    $i++
    if($i -eq 100) { 
        Write-Host "no: $noCount, us: $usCount"
        $i = 0
    }
}
