# Terraform Configuration Explanation

## File Overview

1. **`main.tf`**: Defines the core Azure resources (resource group and storage accounts) using `count` to create multiple storage accounts.
2. **`locals.tf`**: Defines local variables for reusable values, including location and network-related configurations (though the network resources are not used in `main.tf`).

---

## Detailed Breakdown

### 1. `main.tf` - Core Resources with Count

This file defines the Azure resources to be provisioned, leveraging the `count` meta-argument to create multiple storage accounts.

#### Resources Defined:
- **Resource Group** (`azurerm_resource_group`):
  - Name: `app-grp`
  - Location: Defined by `local.resource_location` (set in `locals.tf` as `EastUS`).

- **Storage Accounts** (`azurerm_storage_account`):
  - Count: `3` (creates three storage accounts).
  - Name: Dynamically generated using `${count.index}appstore40000056`:
    - `0appstore40000056` (index 0)
    - `1appstore40000056` (index 1)
    - `2appstore40000056` (index 2)
  - Resource Group: Links to `app-grp`.
  - Location: Same as the resource group (`EastUS`).
  - Account Tier: `Standard` (general-purpose storage).
  - Replication Type: `LRS` (Locally Redundant Storage, cost-effective replication within a single region).
  - Purpose of `count`: The `count` meta-argument allows Terraform to create multiple instances of the `azurerm_storage_account` resource in a single block, with `count.index` providing a unique identifier (0, 1, 2) to differentiate the names.

---

### 2. `locals.tf` - Local Variables

This file defines reusable local values, though not all are utilized in `main.tf`.

- **`resource_location`**:
  - Value: `EastUS`
  - Meaning: Specifies the Azure region for all resources (used by the resource group and storage accounts).

- **`virtual_network`**:
  - Value: A map with:
    - `name`: `app-network`
    - `address_prefixes`: `["10.0.0.0/16"]`
  - Meaning: Defines a virtual network’s name and address space, but this is not referenced in `main.tf`.

- **`subnets`**:
  - Value: A list of subnet configurations:
    - Subnet 1:
      - `name`: `websubnet01`
      - `address_prefixes`: `["10.0.0.0/24"]`
    - Subnet 2:
      - `name`: `appsubnet01`
      - `address_prefixes`: `["10.0.1.0/24"]`
  - Meaning: Defines subnet details, likely intended for a virtual network setup, but not used in the current `main.tf`.

---

## Summary of Infrastructure

This Terraform configuration creates:
- A resource group named `app-grp` in the `EastUS` region.
- Three storage accounts:
  - `0appstore40000056`
  - `1appstore40000056`
  - `2appstore40000056`
  - Each with `Standard` tier and `LRS` replication.

### Purpose of `count`
The use of `count = 3` in the `azurerm_storage_account` resource demonstrates how Terraform can efficiently create multiple instances of a resource. The `count.index` variable (0, 1, 2) is appended to the storage account name to ensure uniqueness, as Azure requires storage account names to be globally unique.

---

## How to Use

1. **Initialize Terraform**:
   ```bash
   terraform init