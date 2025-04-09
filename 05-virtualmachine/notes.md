# Terraform Configuration Explanation

This document explains a set of Terraform configuration files (`main.tf`, `variables.tf`, and `locals.tf`) that define an Azure infrastructure setup. The configuration provisions a resource group, virtual network, subnets, network interface, public IP, network security group, a Windows virtual machine, and an attached managed data disk.

---

## File Overview

1. **`main.tf`**: Defines the core Azure resources, including networking, a VM, and a data disk.
2. **`variables.tf`**: Declares variables for configuring the virtual machine.
3. **`locals.tf`**: Defines local variables for reusable values like location and network configurations.

---

## Detailed Breakdown

### 1. `main.tf` - Core Resources

This file defines the Azure resources to be provisioned.

#### Resources Defined:
- **Resource Group** (`azurerm_resource_group`):
  - Name: `app-grp`
  - Location: Defined by `local.resource_location` (`EastUS`).

- **Virtual Network** (`azurerm_virtual_network`):
  - Name: Defined by `local.virtual_network.name` (`app-network`).
  - Location: `EastUS`.
  - Resource Group: Links to `app-grp`.
  - Address Space: Defined by `local.virtual_network.address_prefixes` (`10.0.0.0/16`).

- **Subnets** (`azurerm_subnet`):
  - Two subnets defined individually (using `local.subnets` list from `locals.tf`):
    - `websubnet01`:
      - Name: `websubnet01`
      - Address Prefixes: `10.0.0.0/24`
    - `appsubnet01`:
      - Name: `appsubnet01`
      - Address Prefixes: `10.0.1.0/24`
  - Linked to `app-network` and `app-grp`.

- **Network Interface** (`azurerm_network_interface`):
  - Name: `webinterface01`
  - Location: `EastUS`.
  - Resource Group: `app-grp`.
  - IP Configuration:
    - Subnet: Connected to `websubnet01`.
    - Private IP: Dynamically allocated.
    - Public IP: Linked to `webip01`.

- **Public IP** (`azurerm_public_ip`):
  - Name: `webip01`
  - Location: `EastUS`.
  - Resource Group: `app-grp`.
  - Allocation: `Static` (fixed IP).

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
    - Source/Destination: Any (`*`)

- **Subnet-NSG Associations** (`azurerm_subnet_network_security_group_association`):
  - Associates `app-nsg` with both subnets:
    - `websubnet01`
    - `appsubnet01`

- **Windows Virtual Machine** (`azurerm_windows_virtual_machine`):
  - Name: Defined by `var.vm_name` (user-provided).
  - Resource Group: `app-grp`.
  - Location: `EastUS`.
  - Size: Defined by `var.vm_size` (defaults to `Standard_B2s`).
  - Admin Username: Defined by `var.admin_username`.
  - Admin Password: Defined by `var.admin_password` (sensitive).
  - Network Interface: Linked to `webinterface01`.
  - OS Disk:
    - Caching: `ReadWrite`
    - Storage Type: `Standard_LRS`
  - Source Image: Windows Server 2016 Datacenter (latest version).
  - VM Agent Updates: Enabled.

- **Managed Disk** (`azurerm_managed_disk`):
  - Name: `datadisk01`
  - Location: `EastUS`.
  - Resource Group: `app-grp`.
  - Storage Type: `Standard_LRS`
  - Create Option: `Empty`
  - Size: 4 GB.

- **Data Disk Attachment** (`azurerm_virtual_machine_data_disk_attachment`):
  - Links `datadisk01` to `webvm01`.
  - LUN: `0` (Logical Unit Number for disk ordering).
  - Caching: `ReadWrite`.

#### Output:
- **`webinterface01_id`**:
  - Value: `azurerm_subnet.websubnet01`
  - Meaning: Outputs the full subnet object for `websubnet01`. This might be a mistake; it likely intended to output `azurerm_network_interface.webinterface01.id` instead.

---

### 2. `variables.tf` - Variable Declarations

This file declares variables used in the configuration.

- **`vm_name`**:
  - Type: `string`
  - Description: Name of the virtual machine (user must provide).

- **`admin_username`**:
  - Type: `string`
  - Description: Admin username for the VM (user must provide).

- **`vm_size`**:
  - Type: `string`
  - Description: Size of the VM.
  - Default: `Standard_B2s` (a cost-effective VM size).

- **`admin_password`**:
  - Type: `string`
  - Description: Admin password for the VM (user must provide).
  - Sensitive: `true` (hides the value in logs/output).

---

### 3. `locals.tf` - Local Variables

This file defines reusable local values.

- **`resource_location`**:
  - Value: `EastUS`
  - Meaning: Specifies the Azure region for all resources.

- **`virtual_network`**:
  - Value: A map with:
    - `name`: `app-network`
    - `address_prefixes`: `["10.0.0.0/16"]`
  - Meaning: Defines the virtual network’s name and address space.

- **`subnets`**:
  - Value: A list of subnet configurations:
    - Subnet 1:
      - `name`: `websubnet01`
      - `address_prefixes`: `["10.0.0.0/24"]`
    - Subnet 2:
      - `name`: `appsubnet01`
      - `address_prefixes`: `["10.0.1.0/24"]`
  - Meaning: Defines subnet details used by the subnet resources.

---

## Summary of Infrastructure

This Terraform configuration creates:
- A resource group named `app-grp` in `EastUS`.
- A virtual network `app-network` with address space `10.0.0.0/16`.
- Two subnets: `websubnet01` (`10.0.0.0/24`) and `appsubnet01` (`10.0.1.0/24`).
- A network interface `webinterface01` in `websubnet01` with a static public IP `webip01`.
- An NSG `app-nsg` allowing RDP (port 3389), associated with both subnets.
- A Windows VM with a user-defined name, size, and credentials, connected to `webinterface01`.
- A 4 GB managed data disk attached to the VM.

---

## How to Use

1. **Set Variables**:
   Create a `terraform.tfvars` file or pass variables via CLI:
   ```hcl
   vm_name         = "webvm01"
   admin_username  = "adminuser"
   admin_password  = "P@ssw0rd1234!"