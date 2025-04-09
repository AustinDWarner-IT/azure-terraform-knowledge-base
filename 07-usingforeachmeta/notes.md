# Terraform Configuration Explanation



---

## File Overview

1. **`main.tf`**: Defines the core Azure resources (resource group, storage account, containers) and an output.
2. **`terraform.tf`**: Configures the Terraform provider (AzureRM) and its credentials.
3. **`locals.tf`**: Defines local variables for reusable values.

---

## Detailed Breakdown

### 1. `main.tf` - Core Resources and Output

This file defines the Azure resources to be provisioned and an output for retrieving container names.

#### Resources Defined:
- **Resource Group** (`azurerm_resource_group`):
  - Name: `app-grp`
  - Location: Defined by `local.resource_location` (set in `locals.tf` as `EastUS`).

- **Storage Account** (`azurerm_storage_account`):
  - Name: Defined by `local.storageaccountname` (`appstore40000056`).
  - Resource Group: Links to `app-grp`.
  - Location: `EastUS`.
  - Account Tier: `Standard` (general-purpose storage).
  - Replication Type: `LRS` (Locally Redundant Storage, cost-effective replication within a single region).

- **Storage Containers** (`azurerm_storage_container`):
  - Created dynamically using a `for_each` loop over a set of names: `["data", "scripts", "logs"]`.
  - Containers:
    - `data`
    - `scripts`
    - `logs`
  - Storage Account: Linked to `appstore40000056`.

#### Output:
- **`container-names`**:
  - Value: `azurerm_storage_container.scripts["data"].name`
  - Meaning: Outputs the name of the `data` container (currently set to only output one container’s name).
  - Note: The configuration includes a comment suggesting the use of the splat operator (`[*]`) to output all container names, but the current output only references the `data` container. To output all three, it could be modified to:
    ```hcl
    output "container-names" {
      value = [for container in azurerm_storage_container.scripts : container.name]
    }