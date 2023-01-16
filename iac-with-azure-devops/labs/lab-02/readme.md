# lab-02 - working with Azure Service Principal

## Goals

When you have applications, hosted services, or automated tools that need to access or modify Azure resources, you need to create an identity for the app. This identity is known as a `Service Principal`. Access to resources is restricted by the roles assigned to the `Service Principal`, giving you control over which resources can be accessed and at which level. 

In this lab you will learn:

* how to create new Service Principal in the Azure Portal
* how to create new Service Principal with `az cli`
* how to store Service Principal credentials to the Key Vault for further re-use
* how to reset Service Principal credentials
* how to manage service principal roles

## Permissions required

You must have sufficient permissions to register an application with your Azure AD tenant, and assign to the application a role in your Azure subscription.
If your Azure AD tenant `App registrations` setting is set to `Yes`, any user in the Azure AD tenant can register an app.
If the `App registrations` setting is set to `No`, only users with elevated Azure AD roles may register these types of applications. Check [Azure AD built-in roles](https://learn.microsoft.com/en-us/azure/active-directory/roles/permissions-reference?WT.mc_id=AZ-MVP-5003837#all-roles) to learn about available administrator roles and the specific permissions in Azure AD that are given to each role. For example, user with `Application Developer` Azure AD role is able to register applications.

## Task #1 - use the portal to create an Azure AD application and service principal that can access resources

There is actually no way to directly create a `Service Principal` using the Azure portal. When you register an application through the Azure portal, an application object and `Service Principal` are automatically created in your tenant. 

### Register new application

To register new application, navigate to `Azure Active Directory`

![images1-1](images/task1-1.jpg)

Select `App registrations` and click `New registration`

![images1-2](images/task1-2.jpg)

Name the application, for example "iac-spn". Set a supported account type to `Single tenant`. 
At this point, we can't create credentials for a Native application. After setting the values, select `Register`.

![images1-2](images/task1-3.jpg)

There are two types of authentication available for service principals: 
 * `password-based` authentication (aka application secret)
 * `certificate-based` authentication. 
 
We will use `password-based` authentication in our lab.

### Create a new application secret

Navigate to `Azure Active Directory -> App registrations` enter app name (`iac-spn`) into the search field and select your application. 

![images1-2](images/task1-4.jpg)

Select `Certificates & secrets`, open `Client secrets` tab and click `New client secret`

![images1-2](images/task1-5.jpg)

Provide a description of the secret, and a duration and click `Add`.

![images1-2](images/task1-6.jpg)

After saving the client secret, the value of the client secret is displayed. You should copy this value if you want  to use it further, because you won't be able to retrieve it later. You should store the secret where you or your application can retrieve it, for example at the Key Vault

![images1-2](images/task1-7.jpg)

### Find Service Principal

As we learned earlier, there are now two objects in Azure AD now:

* `Application object` (under `Application registration`) is used as a template to create service principal object 
* `Service principal object` type of `Application` (under `Enterprice applications`). This is local representation (or application instance), of a global `Application object`

Go back to `iac-spn` Application registration overview page and make note of `Application ID` and `Object ID` values.

![images1-2](images/task1-8.jpg)

Then click at `Managed application in local directory` link. You will be redirected to the Service principal overview page and make note of `Application ID` and `Object ID` values. 

![images1-2](images/task1-9.jpg)

As you can see, the `Application ID` are the same, because both `Application object` and `Service Principal object` represent the same application, but `Object ID` are different, because these are two different objects in Azure AD.



![images1-2](images/task1-8.jpg)

## Useful links

* [Manage service connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml)
* [Common service connection types](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?WT.mc_id=AZ-MVP-5003837&view=azure-devops&tabs=yaml#common-service-connection-types)
* [Application and service principal objects in Azure Active Directory](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals?WT.mc_id=AZ-MVP-5003837)
* [Azure AD built-in roles](https://learn.microsoft.com/en-us/azure/active-directory/roles/permissions-reference?WT.mc_id=AZ-MVP-5003837#all-roles)