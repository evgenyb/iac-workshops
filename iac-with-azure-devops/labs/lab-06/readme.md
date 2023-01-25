# lab-06 - putting it all together, implement workload provisioning script

Let's summarize what have you learned so far:

* you know how to automate creation of Azure Service Principal and store its credentials into Azure KeyVault
* you know how to automate creation of Azure DevOps Service Connection
* you know how to automate creation of Azure DevOps Repository
* you know how to automate creation of Azure DevOps Pipeline

Now you are ready to put it all together and implement one orchestration script that will create all components required for Azure workload provisioning automation.

## Task #1 - implement your workload provisioning script

Here are script requirements:

## Input parameters
* ``WorkloadName``
* ``Environment`` - can be one of dev, test, prod
* ``Owner`` - workload owner
* ``CostCenter`` - can be for example, the name of department or some code representing costs center
* ``DevOpsProject`` - Azure DevOps Project name
* ``Location`` - workload Azure Location defaulted to `norwayeast` (or your default region)

## Implementation details
* Script name should be `Create-Workload.ps1`
* All resources and artifacts should follow [naming convention](../../conventions.md). (Or you can use your own convention if you already have one in your organization). 
* Naming prefix can be defined as input parameter with default value set to `iac` (or your organization prefix). Keep in mind that long prefix will hit you with resources that have limited name length, so keep the prefix short. 

Script should do the following:

* Create Workload Resource Group
* Tag Resource Group with `WorkloadName`, `Owner`, `Environment` and `CostCenter` tags
* Create Workload Service Principal. Implement the logic that checks if Service Principal already exists.
* Store Service Principal credentials into the Azure KeyVault (you can use the one we used at lab2)
* Assign Service Principal `Owner` RBAC role at the Resource Group scope
* Create new Azure DevOps Service Connection under the Azure DevOps project specified as script input parameter. Implement the logic that checks if Service Connection already exists
* (Optional) Think of the scenario if you need to rotate Service Principal credential. How will it affect the script logic
* Create new Azure DevOps Repository under the Azure DevOps project specified as script input parameter. Implement the logic that checks if Repository already exists
* (Optional) Check if branch associated with environment doesn't exist.  Since you will need to adapt IaC code for this environment anyways, does it worth to put this complexity into the script? If the answer is yes, how can you implement this logic?
* Create new Azure DevOps Pipeline under the Azure DevOps project specified as script input parameter. Implement the logic that checks if Pipeline already exists


I've created my version of this [script](../../completed-labs/lab-06/Create-Workload.ps1) and you can use it as a reference implementation, but try to implement it yourself first. I guaranty that you will learn A LOT! :) 

## Task #2 - use your script and provision new workload called `foobar` into  `test` and `prod` environments

If you use my script, don't forget to change `$azureDevOpsOrganization` and `$spnMetadataKeyvaultName` values and install `account` az devops extension.

```powershell
# Install account az cli extension
az extension add -n account
```

1. Provision workload infrastructure for `test` environment 

```powershell
# Provision new workload for `test` environment
./Create-Workload.ps1 -WorkloadName foobar -CostCenter IaC -Owner 'James Bond' -Environment test -DevOpsProject iac -Location norwayeast 
```

2. Clone repository and implement IaC code for `test` environment under `test` branch. 
Remember that:
 * workload name should be set at `deploy.ps1` file (line 6)
 * parameters for `test` environment should be collected in `parameters-test.json` file.
 
3. Deploy workload into `test` environment
Remember that you need top Permit access to Service Connection from the pipeline when you run it for the first time.

4. Provision workload infrastructure for `prod` environment 

```powershell
# Provision new workload for `prod` environment
./Create-Workload.ps1 -WorkloadName foobar -CostCenter IaC -Owner 'James Bond' -Environment prod -DevOpsProject iac -Location norwayeast 

```

5. Create and push new `prod` branch
```powershell
git checkout -b prod
git push --set-upstream origin prod
```

3. Deploy workload into `prod` environment
Remember that you need to Permit access to Service Connection from the pipeline when you run it for the first time.

## Useful links

* [What is Azure DevOps Pipelines?](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)

## Next
[Go to lab-07](../lab-07/readme.md)