# Prerequisites

## Laptop / PC

You need an laptop. OS installed at this laptop doesn't really matter. The tools we use all work cross platforms. I will be using Windows 11 with PowerShell as my shell.

## Microsoft Teams

Download and install [Microsoft Teams](https://products.office.com/en-US/microsoft-teams/group-chat-software)

## Visual Studio Code

Please [download](https://code.visualstudio.com/download) and install VS Code. It's available for all platforms or install it with `winget` (Windows only)

```powershell
winget install -e --id Microsoft.VisualStudioCode
```

## Bicep plugin

Install Bicep plugin from [marketplace](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) 

## Windows Terminal

Download and install [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab&atc=true) or install it with `winget` (Windows only)

```powershell
winget install -e --id Microsoft.WindowsTerminal
```

## Active Azure account

If you don't have an Azure account, please create one before the workshop.
[Create your Azure free account](https://azure.microsoft.com/en-us/free/?WT.mc_id=AZ-MVP-5003837)

## Install `az cli`

Download and install latest version of `az cli` from [this link](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest&WT.mc_id=AZ-MVP-5003837) or install it with `winget` (Windows only)

```powershell
winget install -e --id Microsoft.AzureCLI
```

If you already have `az cli` installed, make sure that you use the latest version. To make sure, run the following command

```powershell
az upgrade
```

## Test your azure account with `az cli`

Open your terminal (bash, cmd or powershell) and login to your azure account by running this command

```bash
# Login using your Azure account
az login

# Get a list of available subscriptions
az account list -o table

# Set subscription by subscription id
az account set --subscription  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

# Set subscription by name
az account set --subscription subscription_name
```

## Install git

```bash
# Install git for Mac
brew install git

# Install git with choco
choco install git

# Install git with winget
winget install Git.Git
```

## Register `Microsoft.Web` resource provider

```powershell
az provider register --namespace Microsoft.Web
```

## Docker Desktop

Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop)

or install it with `winget` (Windows only)

```powershell
winget install -e --id Docker.DockerDesktop
```
