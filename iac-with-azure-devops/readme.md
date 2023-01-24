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
 * [Lab-01](labs/lab-01/readme.md) - provision workshop support resources, get familiar and deploy lab workload
 * [Lab-02](labs/lab-02/readme.md) - working with Azure Service Principal
 * [Lab-03](labs/lab-03/readme.md) - working with Azure DevOps Service Connections
 * [Lab-04](labs/lab-04/readme.md) - working with Azure DevOps Repositories
 * [Lab-05](labs/lab-05/readme.md) - working with Azure DevOps Pipelines
 * Lab-06 - putting it all together, create master script that does everything
 * [Lab-7](labs/lab-07/readme.md) - cleaning up resources

 
## Links

* [Prerequisites](prerequisites.md)


## Feedback

* Visit the [Github Issue](https://github.com/evgenyb/iac-workshops/issues/1) to comment on this workshop. 
