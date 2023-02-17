# lab-01 - provision workshop support resources

## Goals

We will use the following lab environment during the workshop:

The goal of this lab:
* get familiar with lab infrastructure implementation
* deploy lab resources


## Conventions

We use the following [conventions](../../conventions.md) for this workshop.

## Task #1 - deploy lab infrastructure


```powershell
# Navigate to the iac/lab-01 folder

# Deploy lab infrastructure
./deploy.ps1

```

> Note! Deployment takes approx. xx min.


## Task #2 - create your lab dashboard

To improve observability and simplify navigation through lab resources, let's collect all resources under Azure dashboard.

Go to `Dashboards` on Azure portal.

![1](images/1.jpg)

Click `Create`

![2](images/2.jpg)

and select `Custom`

![3](images/3.jpg)

give dashboard a name, for example `IaC Workshop #2` and `Save` it

![3](images/4.jpg)

Now, let's add all resource groups that we just provisioned into this dashboard. The simplest way to do it, is navigate to the Resource group and pin it to the Dashboard.

Open `iac-ws2-rg` resource group and click `pin` icon

![3](images/5.jpg)

at the right window, select `IaC Workshop #2` dashboard from drop-down list and click `Pin`.

![3](images/6.jpg)

Repeat the same process for `iac-ws2-norwayeast-rg` and `iac-ws2-eastus-rg` resource groups.

Now, open the `IaC Workshop #2` dashboard and click `Edit`

![3](images/7.jpg)

now you can resize and move  your resource groups as you like and then click `Save`

![3](images/8.jpg)


## Task #3 - get your VM admin password

The VM admin password was generated and stored as `vmadmin-password` secret at Azure KeyVault. To remotely login to the VMs during the workshop, you will need it, so let's get it out for the keyvault.

```powershell
# Get keyvautl name 
$kvName = (az keyvault list -g iac-ws2-rg --query [0].name -otsv)

# check kv name 
echo $kvName

# Get Admin password from the KV
az keyvault secret show --name vmadmin-password --vault-name $kvName  --query value -otsv
```

## Task #4 - try to login to one of the test VMs

Let's try to remote into one of the VMs to test that all connectivity is working. I will use `testvm-no` here as an example.

Got to `testvm-no` VM and click `Connect->Bastion`

![3](images/9.jpg)

Use `jamesbond` as a `Username`. Use password that you got from the previous task and click `Connect`.

![3](images/10.jpg)

You may get the following warning from your browser. Click `Allow`

![3](images/11.jpg)

If all is good, you will see your VM desktop and you can check the `Don't show this message again` checkbox, so it will not be shown next time you login.

![3](images/12.jpg)

## Next
[Go to lab-02](../lab-02/readme.md)