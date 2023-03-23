# lab-04 - deploy `keyvault-acmebot`

There are several ways you can deploy `keyvault-acmebot`. You can use `Deploy to azure` link from [product main page](https://github.com/shibayan/keyvault-acmebot), but sometimes you need to do some adjustments to the naming conventions, or if you want to allocate components used by the acmebot differently. Int hat case, it's better to implement it with IaC.

`keyvault-acmebot` has both ARM template and Bicep implementations and we will use a Bicep version.

## Task #1 - implement `keyvault-acmebot` with Bicep

We will be working with `iac-keyvault-acmebot-iac` repository during this lab.

Copy the content of [the original](https://github.com/shibayan/keyvault-acmebot/blob/master/azuredeploy.bicep) Bicep file. 

## Useful links


## Next

[Go to lab-05](../lab-05/readme.md)
