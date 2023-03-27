# lab-04 - deploy `keyvault-acmebot`

There are several ways you can deploy `keyvault-acmebot`. The simplest way is to use `Deploy to azure` link from [product main page](https://github.com/shibayan/keyvault-acmebot). It will then create all resources needed for the bot, including some support resource such as Azure KeyVault to store certificates, Azure Log Analytics and Application Insights.
For some simple setup, that's enough, but if you want to use it at your organization, then you may already have Log Analytics and Application Insights resources and you may want to use them instead of creating new ones. Also, you may already have Azure KeyVault for your certificates. For that scenario `keyvault-acmebot` provides you Bicep implementations that you can adjust for your use-case.

## Task #1 - implement `keyvault-acmebot` with Bicep

We will be working with `iac-keyvault-acmebot-iac` repository during this lab.

Copy the content of [the original](https://github.com/shibayan/keyvault-acmebot/blob/master/azuredeploy.bicep) Bicep file. 

## Useful links


## Next

[Go to lab-05](../lab-05/readme.md)
