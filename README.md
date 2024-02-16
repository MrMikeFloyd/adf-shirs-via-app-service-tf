# Introduction 

This repo contains all _infrastructure definitions_ for the ADF PoC. It explores how to:

- build and deploy an Azure Data Pipeline application within an Azure cloud environment
- provision the required resources via IaC and CI/CD tooling

**Please note**: This repo is _work in progress_. Things may not work as intended, and are not ready to be used in productive environments.

# Getting Started

## Azure login/ environment setup

If you'd like to manage/provision the Azure resources from your local machine, make sure that you've logged in to Azure and set your subscription correctly.
This could look as follows:

```
az login
# copy the subscription id from the following list:
az account list --query "[?user.name=='<your-user-id>@email.com'].{Name:name, ID:id, Default:isDefault}" --output Table
az account set --subscription "<your-subscription-id>"
# If all is well, the following command should list the subscription details
az account show
```

## Remote State

Terraform is used as an IaC tool. The Terraform state is managed by a remote backend stored in Azure. See the `remote-state` directory for details. Please make sure that the remote backend is provisioned before continuing.

Once provisioned, note the storage account name as it needs to be referenced from the ADF Terraform stack (inside `adf/main.tf`). It is included in the `remote-state` outputs (look for a CLI output like `remote_state_storage_account_name = "adfpoc12345"`).

# Further reading

## Resource management for ADF infrastructure
- [Terraform remote state management in Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=terraform)
- [Data Factory Sample implementation](https://medium.com/twodigits/deploy-your-azure-data-factory-through-terraform-2a9c2bd2d75d)

## CI/CD for ADF
- [ADF CI/CD best practices by Microsoft](https://learn.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery)
- [ADF CI/CD in action (part 1)](https://www.nathannellans.com/post/ci-cd-with-azure-data-factory-part-1)
- [ADF CI/CD in action (part 2)](https://www.nathannellans.com/post/ci-cd-with-azure-data-factory-part-2)

## ADF SHIRs on Azure App Service

To get around running self hosted integration runtimes (SHIRs) as VMs, they can be run as (Windows only) containers inside Azure AppService.

- [ADF SHIRs on Azure App Service](https://github.com/Azure-Samples/azure-data-factory-runtime-app-service/tree/main)
