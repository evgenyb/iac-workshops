# lab-02 - working with Azure Load Balancer

## Task #1 - create a public Azure Load Balancer to load balance two Virtual Machines using portal

## Task #2 - add outbound rules to Azure Load Balancer using portal

## Task #3 - run `k6` load tests against load balancer 

Get `fqdn` of public ip of load balancer

```powershell
# get fqdn of public ip assigned to load balancer
az network public-ip show -n iac-ws2-norwayeast-alb-pip -g iac-ws2-norwayeast-rg  --query dnsSettings.fqdn -otsv
```

Create new `script.js` file with following content

```javascript
import http from 'k6/http';
import { sleep } from 'k6';

export default function () {
  http.get('http://fqdn_from_previous_step');
  sleep(1);
}
```

run k6 with this command:
    
```powershell
# run k6 with 50 virtual users for 5 minutes
k6 run --vus 50 --duration 10m script.js
```

k6 run --vus 10 --duration 30s script.js
```

## Task #3 - monitor Azure Load Balancer

## Task #4 - load balancer metrics snd diagnostics

> Deployment takes approx. 6 min.

## Links

https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-bicep?tabs=CLI
https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/quick-create-bicep-windows?tabs=CLI
https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-connect-to-instances-cli
https://learn.microsoft.com/en-us/azure/load-balancer/backend-pool-management
https://learn.microsoft.com/en-us/azure/load-balancer/monitor-load-balancer
https://learn.microsoft.com/en-us/azure/load-balancer/outbound-rules

## Next
[Go to lab-03](../lab-03/readme.md)