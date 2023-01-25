# lab-07 - cleaning up resources

When you are done, make sure that the following resource are deleted from your Azure and Azure DevOps accounts:

* Service Principals
* Resource Groups
* Azure DevOps Repos, Pipelines and Service Connections

If you followed workshop naming convention, all resource names start with `iac-`. You can either manually remove them at the portal, or write a simple script that does the cleanup.

Even better, you can (and in your production environment should), have cleanup script that removes workload related resources.