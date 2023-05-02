
## Deployment

### Deploy infrastructure

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fevgenyb%2Fiac-workshops%2Fws%2Faca%2Fcontainer-apps%2Fiac%2Finfra.json" target="_blank"><img src="https://aka.ms/deploytoazurebutton" /></a>

### Push image to ACR


### Deploy test app

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fevgenyb%2Fiac-workshops%2Fws%2Faca%2Fcontainer-apps%2Fiac%2FtestApp.json" target="_blank"><img src="https://aka.ms/deploytoazurebutton" /></a>

```powershell
az deployment group create --resource-group iac-ws4-rg --template-file .\testApp.bicep --name testApp
```