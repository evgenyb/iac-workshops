# Infrastructure as Code workshops

This repository contains a series of hands-on workshops covering different aspects of working with Infrastructure as Code on Azure.

All workshops are a combination of theoretical blocks with slides and hands-on labs. Normally, the estimated time of workshop completion is between 3 and 4 hours.

## [Load-balancing options on Azure](azure-load-balancing-options/readme.md)

This is level 200 workshop that covers different aspects of working with load-balancing services on Azure where you will learn:

* What load-balancing options are available on Azure
* How to choose a load balancing solution for your workload
* What traffic routing methods are available at Azure Front Door
* How to implement canary releases with Azure Traffic Manager
* How to rewrite HTTP headers and URL with Azure Application Gateway

and many many more...

## [Automate Azure workload provisioning with Bicep, Powershell and Azure DevOps](iac-with-azure-devops/readme.md)

This is an introduction level workshop that covers different aspects of automating infrastructure provisioning on Azure with DevOps and you will learn:

* What is Azure Service Principal, how to create it and how to properly scope it's RBAC permissions for your workload
* How to use `az devops` extension to automate Azure DevOps operations 
* How to create Azure DevOps Service Connection for workload Service Principal with `az devops` cli
* How to create IaC git Repository in Azure DevOps based on your Template repository
* How to create Azure DevOps IaC deployment pipeline using `az devops` cli
* What strategies are available to implement IaC for multi-environment workloads

