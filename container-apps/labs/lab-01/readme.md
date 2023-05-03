
## Deployment


### Register required resource providers

Before we deploy lab resources, we need to register required resource providers. This is a one time operation per subscription.

```powershell
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.Storage
```

### Deploy infrastructure

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fevgenyb%2Fiac-workshops%2Fws%2Faca%2Fcontainer-apps%2Fiac%2Finfra.json" target="_blank"><img src="https://aka.ms/deploytoazurebutton" /></a>

### Push image to ACR

```powershell
# get your acr name
$acrName = (az acr list -g iac-ws4-rg  --query [0].name -otsv)

# login into acr
az acr login -n $acrName
```

### Deploy test app

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fevgenyb%2Fiac-workshops%2Fws%2Faca%2Fcontainer-apps%2Fiac%2FtestApp.json" target="_blank"><img src="https://aka.ms/deploytoazurebutton" /></a>

```powershell
az deployment group create --resource-group iac-ws4-rg --template-file .\testApp.bicep --name testApp
```