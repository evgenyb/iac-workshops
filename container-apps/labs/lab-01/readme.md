
## Deployment


### Register required resource providers

Before we deploy lab resources, we need to register required resource providers. This is a one time operation per subscription.

```powershell
az provider register -n Microsoft.ContainerService
az provider register -n Microsoft.ContainerRegistry
az provider register -n Microsoft.Network
az provider register -n Microsoft.OperationalInsights
az provider register -n Microsoft.App
az provider register -n Microsoft.Storage
az provider register -n Microsoft.ServiceLinker
az provider register -n Microsoft.ManagedIdentity
az provider register -n Microsoft.Compute
```

### Deploy infrastructure

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fevgenyb%2Fiac-workshops%2Fws%2Faca%2Fcontainer-apps%2Fiac%2Finfra.json" target="_blank"><img src="https://aka.ms/deploytoazurebutton" /></a>

### Build and push image to ACR

```powershell
# get your acr name
$acrName = (az acr list -g iac-ws4-rg  --query [0].name -otsv)

# login into acr
az acr login -n $acrName

# cd to the api-a folder
cd container-apps\src\apps\api-a

# make sure that you are at the correct folder
pwd

# build image
docker build -t apia:latest -f Dockerfile ..

# Tag the image with the full ACR login server name. 
docker tag apia:latest "$acrName.azurecr.io/apia:latest"

# Push the image to the ACR instance.
docker push "$acrName.azurecr.io/apia:latest"
```

### Deploy test app

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fevgenyb%2Fiac-workshops%2Fws%2Faca%2Fcontainer-apps%2Fiac%2FtestApp.json" target="_blank"><img src="https://aka.ms/deploytoazurebutton" /></a>

### Test api

```powershell
# get private dns zone name
$dnsZoneName = (az network private-dns zone list -g iac-ws4-rg --query [0].name -otsv)

# test api 
curl https://iac-ws4-test-capp.$dnsZoneName/health
```

You should get `ok` response.
