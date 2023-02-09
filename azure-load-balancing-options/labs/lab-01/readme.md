# lab-01 - provision workshop support resources

## AGW with VMs 

```powershell
# Deploy VM to norwayeast
az deployment sub create -l norwayeast --template-file template.bicep -p parameters.json -n lab01
```

> Deployment takes approx. xx min.

## Links


## Next
[Go to lab-02](../lab-02/readme.md)