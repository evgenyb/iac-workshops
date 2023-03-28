# lab-04 - deploy `keyvault-acmebot`

There are several ways you can deploy `keyvault-acmebot` to Azure.

## `Use Azure Portal (ARM Template)`

Use the link from [product main page](https://github.com/shibayan/keyvault-acmebot#deployment) and specify the following deployment parameters:

    - `Subscription` - Azure subscription where you want to deploy the bot
    - `Resource Group` - Azure resource group where you want to deploy the bot
    - `Location` - the location of the function app that you wish to create
    - `App Name Prefix` - the name of the function app that you wish to create
    - `Mail Address` - email address for ACME account
    - `Acme Endpoint` - certification authority ACME Endpoint, default is LetsEncrypt https://acme-v02.api.letsencrypt.org/
    - `Create With Key Vault` - if you choose true, create and configure a key vault at the same time
    - `Key Vault Sku Name` - specifies whether the key vault is a standard vault or a premium vault
    - `Key Vault Base Url` - the base URL of an existing Key Vault

![Deploy to Azure](images/1.png)

It will then create all resources needed for the bot, including Azure KeyVault to store certificates, Storage Account to store state, Azure Log Analytics and Application Insights for monitoring. It will of course create Service plan and deploy Azure Function App and configure it to run the bot.

For some simple setup, that's enough, you can deploy it once, document deployment steps and off you go.

## Use Bicep Module

If you want to deploy it as IaC, you can use Bicep module from Private Registry with public access. Here is the [documentation](https://github.com/shibayan/keyvault-acmebot/issues/427).

Here is one possible implementation:

```bicep
module acmebot 'br:cracmebotprod.azurecr.io/bicep/modules/keyvault-acmebot:v3' = {
  name: 'acmebot'
  params: {
    appNamePrefix: 'iac'
    mailAddress: 'your@email-address.com'
    createWithKeyVault: true
    keyVaultSkuName: 'standard'
  }
}
```

With this setup, you can programmatically configure whether you want to create KeyVault as part of the deployment or use existing one. As with the first option, for most of the cases, this is enough. And it's better than the first option, because you can deploy it as IaC and automate it with CI/CD pipeline.

Nether first nor second option allows you programmatically configure any of the [DNS Provider Configuration](https://github.com/shibayan/keyvault-acmebot/wiki/DNS-Provider-Configuration). You need to do it manually every time you redeploy `keyvault-acmebot`. Another limitation of the current version of IaC implementation is that you can't use existing Log Analytics. It will always create new one.

## Copy Bicep file and adjust it

If you want programmatically configure DNS Provider Configuration and configure wether you want to create a new Log Analytics or use existing one, then you need to implement it yourself. The downside of this approach is that you need to maintain it yourself. If `keyvault-acmebot` project will update their Bicep file or configuration contract, you need to update your copy as well. This is the price you pay for the flexibility and this is decision you need to make at your project.

There are several techniques how you can minimize the maintenance work. One approach could be to fork the original repository and maintain your own copy. Then you periodically sync your fork with the original repository and if there are any conflicts because of you custom implementation, you can fix them as a regular merge conflict exercise.

Another approach (and this is the best one in my opinion), is to contribute into the repo by creating the PR with your implementation.

For this lab, lets' implement the third option!

## Task #1 - implement `keyvault-acmebot` with Bicep

We will be working with `iac-keyvault-acmebot-iac` repository during this lab.

Here is the [the original](https://github.com/shibayan/keyvault-acmebot/blob/master/azuredeploy.bicep) `keyvault-acmebot` Bicep file.

Here are the requirements for our implementation:

- we want configure if `keyvault-acmebot` uses existing Log Analytics workspace or create new one
- if use existing Log Analytics workspace, we want to specify the workspace resource id
- we want to configure DNS Provider Configuration as an array of name, value objects

Feel free to implement it yourself. This is a very good exercise mastering your Bicep skills :)

You can find my implementation version [here](../../completed-labs/lab-04/src/modules/keyvault-acmebot.bicep) and here are the changes I made.

1. I added conditional deployment for `workspace` resource

```bicep
...
resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = if (createWithLogAnalytics) {
...
```

2. The `WorkspaceResourceId` property of `appInsights` resource calculated based on the `createWithLogAnalytics` parameter.

```bicep
...
WorkspaceResourceId: (createWithLogAnalytics ? workspace.id : logAnalyticsWorkspaceResourceId)
...
```

3. Application settings are merged with `dnsProviderConfiguration` array.

```bicep
...
appSettings: concat(appSettings, dnsProviderConfiguration)
...
```  

Now, copy content of the [completed labs](../../completed-labs/lab-04) folder into the `iac-keyvault-acmebot-iac` local repository.

Set the following parameters of the `parameters.json` file

### keyVaultBaseUrl

Get your Azure Keyvault URL. You can do it at the portal or with cli:

```powershell
# Get KeyVault URL
az keyvault list -g iac-domains-rg --query [0].properties.vaultUri -otsv
```

### logAnalyticsWorkspaceResourceId

### dnsProviderConfiguration

Since we use Azure DNS as a DNS provider, we need to configure [DNS Provider Configuration for Azure DNS](https://github.com/shibayan/keyvault-acmebot/wiki/DNS-Provider-Configuration#app-settings-1). Basically, we need to specify the subscription id where the DNS zone is located. Set your subscription id as a value of `Acmebot:AzureDns:SubscriptionId` key.

```powershell
# Get Subscription ID
az account show --query id -o tsv
```

### mailAddress

Set your email address.

## Useful links

## Next

[Go to lab-05](../lab-05/readme.md)
