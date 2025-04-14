# Terraform Configuration Explanation
# Force push all files


This document explains a set of Terraform configuration files (`main.tf`, `locals.tf`, `security.tf`, `terraform.tf`, `terraform.tfvars`, and `variables.tf`) that define an Azure infrastructure setup. The configuration provisions a resource group, virtual network, subnets, network interface, public IP, network security group, and a Windows virtual machine. A key focus is the integration of **Azure Key Vault (AKV) secrets** to securely manage the VM's admin password, enhancing security by avoiding hardcoded credentials.

---

## File Overview

1. **`main.tf`**: Defines the core Azure resources, including the VM that uses an AKV secret for its password.
2. **`locals.tf`**: Defines local variables for reusable values like location.
3. **`security.tf`**: Configures Azure Key Vault integration and secret management (the highlight of this setup).
4. **`terraform.tf`**: Configures the Terraform provider (AzureRM) and credentials.
5. **`terraform.tfvars`**: Provides specific values for the `app_environment` variable.
6. **`variables.tf`**: Declares variables, including the sensitive admin password and environment configuration.

---

## Detailed Breakdown

### 1. `main.tf` - Core Resources

This file defines the Azure resources, with the VM leveraging an AKV secret.

#### Resources Defined:
- **Resource Group** (`azurerm_resource_group`):
  - Name: `app-grp`
  - Location: Defined by `local.resource_location` (`EastUS`).

- **Virtual Network** (`azurerm_virtual_network`):
  - Name: `var.app_environment.production.virtualnetworkname` (`app-network`).
  - Location: `EastUS`.
  - Resource Group: Links to `app-grp`.
  - Address Space: `var.app_environment.production.virtualnetworkcidrblock` (`10.0.0.0/16`).

- **Subnets** (`azurerm_subnet`):
  - Created dynamically using a `for_each` loop over `var.app_environment.production.subnets`:
    - `websubnet01`: `10.0.0.0/24`
    - `websubnet02`: `10.0.1.0/24`
    - `websubnet03`: `10.0.2.0/24`
  - Linked to `app-network` and `app-grp`.

- **Network Interface** (`azurerm_network_interface`):
  - Name: `var.app_environment.production.networkinterfacename` (`webinterface01`).
  - Location: `EastUS`.
  - Resource Group: `app-grp`.
  - IP Configuration:
    - Subnet: Connected to `websubnet01`.
    - Private IP: Dynamically allocated.
    - Public IP: Linked to `webip01`.

- **Public IP** (`azurerm_public_ip`):
  - Name: `var.app_environment.production.publicipaddressname` (`webip01`).
  - Resource Group: `app-grp`.
  - Location: `EastUS`.
  - Allocation: `Static`.

- **Network Security Group (NSG)** (`azurerm_network_security_group`):
  - Name: `app-nsg`
  - Location: `EastUS`.
  - Resource Group: `app-grp`.
  - Security Rule:
    - Name: `AllowRDP`
    - Priority: 300
    - Direction: Inbound
    - Access: Allow
    - Protocol: TCP
    - Destination Port: 3389 (RDP)
    - Source/Destination: Any (`*`).

- **Subnet-NSG Association** (`azurerm_subnet_network_security_group_association`):
  - Associates `app-nsg` with all subnets.

- **Windows Virtual Machine** (`azurerm_windows_virtual_machine`):
  - Name: `var.app_environment.production.virtualmachinename` (`webvm01`).
  - Resource Group: `app-grp`.
  - Location: `EastUS`.
  - Size: Hardcoded as `Standard_B2s`.
  - Admin Username: Hardcoded as `appadmin`.
  - **Admin Password**: Sourced from `azurerm_key_vault_secret.vmpassword.value` (securely retrieved from AKV).
  - Network Interface: Linked to `webinterface01`.
  - OS Disk:
    - Caching: `ReadWrite`
    - Storage Type: `Standard_LRS`
  - Source Image: Windows Server 2016 Datacenter (latest version).
  - VM Agent Updates: Enabled.

---

### 2. `locals.tf` - Local Variables

This file defines reusable local values.

- **`resource_location`**:
  - Value: `EastUS`
  - Meaning: Specifies the Azure region for all resources.

---

### 3. `security.tf` - Azure Key Vault Secrets (Key Focus)

This file integrates Azure Key Vault for secure password management, the centerpiece of this configuration.

- **Key Vault Data Source** (`data "azurerm_key_vault"`):
  - Name: `appvault2123246`
  - Resource Group: `security-grp` (assumed pre-existing).
  - Purpose: References pre-existing Key Vault to retrieve its ID for secret storage.

- **Key Vault Secret** (`azurerm_key_vault_secret`):
  - Name: `vmpassword`
  - Value: `var.admin_password` (user-provided sensitive value).
  - Key Vault ID: Links to `appvault2123246`.
  - **Significance**: Stores the VM admin password securely in Azure Key Vault, allowing the VM to retrieve it dynamically at provisioning time rather than hardcoding it in the configuration. This enhances security by:
    - Preventing exposure in source code or logs.
    - Centralizing credential management.
    - Enabling rotation or updates without modifying Terraform files.

#### Why AKV Secrets Matter
Using AKV secrets ensures sensitive data like the VM password is encrypted, access-controlled, and auditable. The VM retrieves the password (`azurerm_key_vault_secret.vmpassword.value`) at runtime, aligning with security best practices.

---

### 4. `terraform.tf` - Provider Configuration

This file configures Terraform and the Azure provider.

- **Terraform Block**:
  - Specifies the required provider:
    - `azurerm` (Azure Resource Manager)
    - Source: `hashicorp/azurerm`
    - Version: `4.25.0`


----

### 5. `terraform.tfvars` - Variable Values

This file provides values for the `app_environment` variable.

- **`app_environment`**:
  - `production`:
    - `virtualnetworkname`: `app-network`
    - `virtualnetworkcidrblock`: `10.0.0.0/16`
    - `subnets`:
      - `websubnet01`: `10.0.0.0/24`
      - `websubnet02`: `10.0.1.0/24`
      - `websubnet03`: `10.0.2.0/24`
    - `networkinterfacename`: `webinterface01`
    - `publicipaddressname`: `webip01`
    - `virtualmachinename`: `webvm01`

---

### 6. `variables.tf` - Variable Declarations

This file declares variables used in the configuration.

- **`app_environment`**:
  - Type: `map(object({...}))`
  - Meaning: A structured map for environment-specific settings (e.g., production).

- **`admin_password`**:
  - Type: `string`
  - Description: Admin password for the VM.
  - Sensitive: `true` (hides value in logs/output).
  - **Role**: Feeds into the AKV secret, ensuring secure handling of the password.

---

## Summary of Infrastructure

This Terraform configuration creates:
- A resource group named `app-grp` in `EastUS`.
- A virtual network `app-network` with address space `10.0.0.0/16`.
- Three subnets: `websubnet01`, `websubnet02`, `websubnet03`.
- A network interface `webinterface01` with a static public IP `webip01`.
- An NSG `app-nsg` allowing RDP, associated with all subnets.
- A Windows VM `webvm01` with its admin password securely sourced from Azure Key Vault.

### Emphasis on AKV Secrets
The standout feature is the use of `azurerm_key_vault_secret` to store and retrieve the VM’s admin password. This replaces hardcoded credentials (e.g., `Admin123@`) with a secure, managed secret, improving security and maintainability.

---

## How to Use

1. **Set Variables**:
   Add `admin_password` to `terraform.tfvars` or pass via CLI:
   ```hcl
