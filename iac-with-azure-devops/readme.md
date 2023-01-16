# Automate Azure workload provisioning with Bicep, Powershell and Azure DevOps

![logo](images/logo.jpg)

This is an introduction level workshop that covers different aspects of automating infrastructure provisioning on Azure with DevOps and you will learn:

* What is Azure Service Principal, how to create it and how to properly scope it's RBAC permissions for your workload
* How to use Azure DevOps REST APIs to automate Azure DevOps operations
* How to use `az devops` extension to automate Azure DevOps operations 
* How to create Azure DevOps Service Connection for workload Service Principal with `az devops` cli
* How to create IaC git Repository in Azure DevOps based on your Template repository
* How to create Azure DevOps IaC deployment pipeline using `az devops` cli
* What strategies are available to implement IaC for multi-environment workloads


## Agenda
 
 * Welcome + practical information
 * Automate infrastructure provisioning with Azure DevOps
 * [Lab-01](labs/lab-01/readme.md) - provision workshop resources and get familiar with IaC code
 * Lab-02 - working with Azure Service Principal
 * Lab-03 - working with Azure DevOps Service Connections
 * Lab-04 - use Azure DevOps REST APIs to automate Azure DevOps operations
 * Lab-05 - use `az devops` extension to automate Azure DevOps operations 
 * Lab-06 - create ADO Azure Service Connection using `az devops`
 * Lab-07 - create ADO Repository using `az devops`
 * Lab-08 - create ADO release pipeline
 * Lab-09 - putting it all together, create master script that does everything
 * [Lab-10](labs/lab-08/readme.md) - cleaning up resources

 
## Links

* [Prerequisites](prerequisites.md)


## Feedback

* Visit the [Github Issue](https://github.com/evgenyb/iac-workshops/issues/1) to comment on this workshop. 
