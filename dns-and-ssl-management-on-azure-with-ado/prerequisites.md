# Prerequisites

## Domain name

For this workshop you will need a domain name. This is unfortunately a must. If you're planning to learn or use publicly facing Azure products that requires custom domains, it will be a good investment to have a domain name that you can use for testing purposes.
If you already own a domain name, you can use it and transfer it to Azure DNS as part of the workshop. But I would recommend to use a new domain. 
You can search and buy a domain name from [accredited domain registrars](https://www.icann.org/registrar-reports/accredited-list.html) for very little cost. For example, if you buy `foo-bar.eu` from GoDaddy now, it will cost you [less than $3 for 1 year](https://www.godaddy.com/domainsearch/find?checkAvail=1&segment=repeat&domainToCheck=foo-bar.eu) and you can find even cheaper options. And, you can always cancel yearly payment for the domain if you don't want to pay for it anymore. 

If you already own a domain and it's managed under Azure DNS Zone, you don't need to do anything. 

## Laptop / PC

You need an laptop. OS installed at this laptop doesn't really matter. The tools we use all work cross platforms. I will be using Windows 11 with PowerShell as my shell.

## Microsoft Teams

Download and install [Microsoft Teams](https://products.office.com/en-US/microsoft-teams/group-chat-software)

## Visual Studio Code

Please download and install VS Code. It's available for all platforms.
[Download Visual Studio Code](https://code.visualstudio.com/download)

## Bicep plugin

Install Bicep plugin from [marketplace](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) 
 
## Windows Terminal

Download and install [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab&atc=true)

## Active Azure account

If you don't have an Azure account, please create one before the workshop.
[Create your Azure free account](https://azure.microsoft.com/en-us/free/?WT.mc_id=AZ-MVP-5003837)

## Active DevOps account

If you don't have an Azure DevOps, please create one before the workshop.
[Azure DevOps - start for free](https://azure.microsoft.com/en-gb/services/devops/)

## Create a new Azure DevOps Project

Follow this [how-to guide](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page) and create a new project (or use existing one, if you already have one).

## Install `az cli`

Download and install latest version of `az cli` from this link  
[Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest&WT.mc_id=AZ-MVP-5003837)

If you already have `az cli` installed, make sure that you use the latest version. To make sure, run the following command

```bash
az upgrade

This command is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus
Your current Azure CLI version is 2.19.0. Latest version available is 2.19.1.
Please check the release notes first: https://docs.microsoft.com/cli/azure/release-notes-azure-cli
Do you want to continue? (Y/n): Y
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