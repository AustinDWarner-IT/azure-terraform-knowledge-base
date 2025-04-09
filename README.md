# Terraform Configuration Explanation

This document explains a set of Terraform configuration files (`main.tf`, `variables.tf`, and `locals.tf`) that define an Azure infrastructure setup. The configuration provisions a resource group, virtual network, subnets, network interfaces, public IPs, a network security group, and multiple Windows virtual machines distributed across availability zones using the `count` meta-argument and the `zone` attribute.

---

## File Overview

1. **`main.tf`**: Defines the core Azure resources, including networking and multiple VMs with availability zones.
2. **`variables.tf`**: Declares variables for network interface count, subnet information, and VM size.
3. **`locals.tf`**: Defines local variables for reusable values like location and virtual network configuration.

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
  - Created dynamically using a `for_each` loop based on `var.subnet_information` (must be provided via `terraform.tfvars` or CLI).
  - Example Subnets (assuming user input):
    - `websubnet01`: CIDR block defined by `var.subnet_information["websubnet01"].cidrblock`.
  - Linked to `app-network` and `app-grp`.

- **Network Interfaces** (`azurerm_network_interface`):
  - Count: Defined by `var.network_interface_count` (user-provided).
  - Names: `webinterface-1`, `webinterface-2`, etc. (based on `count.index+1`).
  - Location: `EastUS`.
  - Resource Group: `app-grp`.
  - IP Configuration:
    - Subnet: Connected to `websubnet01`.
    - Private IP: Dynamically allocated.
    - Public IP: Linked to corresponding `azurerm_public_ip.webip` instances.

- **Public IPs** (`azurerm_public_ip`):
  - Count: Matches `var.network_interface_count`.
  - Names: `webip01`, `webip02`, etc.
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
  - Associates `app-nsg` with all subnets created via `for_each`.

- **Windows Virtual Machines** (`azurerm_windows_virtual_machine`):
  - Count: Matches `var.network_interface_count`.
  - Names: `webvm01`, `webvm02`, etc.
  - Resource Group: `app-grp`.
  - Location: `EastUS`.
  - Size: Defined by `var.vm_size` (defaults to `Standard_B2s`).
  - Admin Username: Hardcoded as `appadmin`.
  - Admin Password: Hardcoded as `Admin123@` (not recommended for production).
  - Availability Zone: `zone = (count.index) + 1` (e.g., VM1 in Zone 1, VM2 in Zone 2, etc.).
  - Network Interface: Each VM links to a corresponding `webinterface` (e.g., `webvm01` uses `webinterface-1`).
  - OS Disk:
    - Caching: `ReadWrite`
    - Storage Type: `Standard_LRS`
  - Source Image: Windows Server 2016 Datacenter (latest version).
  - VM Agent Updates: Enabled.

---

### 2. `variables.tf` - Variable Declarations

This file declares variables used in the configuration.

- **`network_interface_count`**:
  - Type: `number`
  - Description: Controls the number of network interfaces and VMs.

- **`subnet_information`**:
  - Type: `map(object({cidrblock=string}))`
  - Meaning: A map where each key is a subnet name, and the value specifies its CIDR block.

- **`vm_size`**:
  - Type: `string`
  - Description: Size of the VMs.
  - Default: `Standard_B2s`.


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

---

## Summary of Infrastructure

This Terraform configuration creates:
- A resource group named `app-grp` in `EastUS`.
- A virtual network `app-network` with address space `10.0.0.0/16`.
- Subnets defined by `var.subnet_information` (e.g., `websubnet01`).
- Multiple network interfaces and public IPs (count based on `var.network_interface_count`).
- An NSG `app-nsg` allowing RDP, associated with all subnets.
- Multiple Windows VMs (e.g., `webvm01`, `webvm02`), each with a network interface, public IP, and placed in sequential availability zones (e.g., Zone 1, Zone 2).

### Availability Zones
- The `zone = (count.index) + 1` attribute assigns each VM to a different availability zone (e.g., 1, 2, 3), enhancing redundancy by distributing VMs across physically separate data centers within the `EastUS` region. Note: `EastUS` supports 3 zones, so `network_interface_count` should not exceed 3 unless zones are reused or skipped.

---

## How to Use

1. **Set Variables**:
   Create a `terraform.tfvars` file or pass variables via CLI:
   ```hcl
   network_interface_count = 2
   subnet_information = {
     "websubnet01" = { cidrblock = "10.0.0.0/24" }
     "appsubnet01" = { cidrblock = "10.0.1.0/24" }
   }