# Terraform Configuration for Azure Storage Setup

This document explains two Terraform configuration files (`main.tf`) that provision an Azure Storage Account, a Blob Container, and upload a sample blob file. These configurations are designed to work with the Azure Resource Manager (ARM) provider.

## Prerequisites
- Terraform installed (version compatible with `azurerm` provider `4.25.0`).
- An Azure account with a valid subscription.
- Azure credentials (Client ID, Client Secret, Tenant ID, Subscription ID) configured for authentication.

## File 1: `main.tf` (First Version)

### Overview
This configuration creates:
1. An Azure Resource Group.
2. A Storage Account.
3. A Blob Container named `scripts`.
4. A Blob file (`testfile.txt`) uploaded to the container.

### Code Breakdown
#### Provider Configuration
```hcl
provider "azurerm" {
  features {}
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
  subscription_id = ""
}
Configures the azurerm provider with credentials for authentication.
The features {} block is required but left empty as no specific features are customized.
Resource Group
hcl

Collapse

Wrap

Copy
resource "azurerm_resource_group" "app-grp" {
  name     = "app-grp"
  location = "North Europe"
}
Creates a resource group named app-grp in the North Europe region.
Storage Account
hcl

Collapse

Wrap

Copy
resource "azurerm_storage_account" "appstore0154545454" {
  name                     = "appstore0154545454"
  resource_group_name      = azurerm_resource_group.appgrp.name
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
Provisions a storage account named appstore0154545454.
References the resource group dynamically using azurerm_resource_group.appgrp.name.
Uses the Standard tier with LRS (Locally Redundant Storage).
Blob Container
hcl

Collapse

Wrap

Copy
resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_id    = azurerm_storage_account.appstore0154545454.id
}
Creates a container named scripts within the storage account.
Links to the storage account using its id.
Blob File
hcl

Collapse

Wrap

Copy
resource "azurerm_storage_blob" "testfile" {
  name                   = "testfile.txt"
  storage_account_name   = azurerm_storage_account.appstore0154545454.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "testfile.txt"
}
Uploads a file named testfile.txt to the scripts container.
Uses dynamic references for the storage account and container names.
Assumes testfile.txt exists in the local directory where Terraform is executed.
Notes
There’s a typo in resource_group_name = azurerm_resource_group.appgrp.name (should be app-grp, not appgrp in the reference).
File 2: main.tf (Second Version)
Overview
This version is similar to the first but adjusts how resources are referenced and fixes some issues.

Code Breakdown
Provider Configuration
Identical to the first version.
Resource Group
hcl

Collapse

Wrap

Copy
resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "North Europe"
}
Same as the first version, but the resource name is appgrp (no hyphen).
Storage Account
hcl

Collapse

Wrap

Copy
resource "azurerm_storage_account" "appstore0154545454" {
  name                     = "appstore0154545454"
  resource_group_name      = "app-grp"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
Hardcodes the resource group name ("app-grp") instead of using a reference.
Blob Container
hcl

Collapse

Wrap

Copy
resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_id    = "/subscriptions/700cd528-e89f-4c0c-81b6-2196bb404191/resourceGroups/app-grp/providers/Microsoft.Storage/storageAccounts/appstore0154545454"
}
Uses a hardcoded ARM resource ID for the storage account instead of a dynamic reference.
Blob File
hcl

Collapse

Wrap

Copy
resource "azurerm_storage_blob" "testfile" {
  name                   = "testfile.txt"
  storage_account_name   = "appstore0154545454"
  storage_container_name = "scripts"
  type                   = "Block"
  source                 = "testfile.txt"
}
Hardcodes the storage account and container names instead of using references.
Key Differences Between the Two Files
Resource Group Reference:
File 1: Uses azurerm_resource_group.appgrp.name (dynamic, but has a typo).
File 2: Hardcodes "app-grp".
Storage Account ID in Container:
File 1: Uses azurerm_storage_account.appstore0154545454.id (dynamic).
File 2: Uses a hardcoded ARM ID.
Blob Resource References:
File 1: Uses dynamic references (e.g., azurerm_storage_container.scripts.name).
File 2: Hardcodes names (e.g., "scripts").
Consistency:
File 1 is more Terraform-idiomatic with dynamic references but has a typo.
File 2 avoids references, making it less flexible but more explicit.