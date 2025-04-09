# Terraform Configuration Explanation

This document explains a set of Terraform configuration files (`main.tf`, `terraform.tfvars`, `terraform.tf`, `variables.tf`, and `locals.tf`) that define an Azure infrastructure setup. The configuration provisions a resource group, virtual network, subnets, network interfaces, public IPs, a network security group (NSG), and associates the NSG with subnets.

---

## File Overview

1. **`main.tf`**: Defines the core Azure resources to be created.
2. **`terraform.tfvars`**: Provides specific values for variables used in the configuration.
3. **`terraform.tf`**: Configures the Terraform provider (AzureRM) and its credentials.
4. **`variables.tf`**: Declares variables used across the configuration.
5. **`locals.tf`**: Defines local variables for reusable values.

---

## Detailed Breakdown

### 1. `main.tf` - Core Resources

This file defines the Azure resources to be provisioned.

#### Resources Defined:
- **Resource Group** (`azurerm_resource_group`):
  - Name: `app-grp`
  - Location: Defined by `local.resource_location` (set in `locals.tf` as `EastUS`).
  
- **Virtual Network** (`azurerm_virtual_network`):
  - Name: Defined by `local.virtual_network.name` (`app-network`).
  - Location: Same as the resource group (`EastUS`).
  - Resource Group: Links to `app-grp`.
  - Address Space: Defined by `local.virtual_network.address_prefixes` (`10.0.0.0/16`).

- **Subnets** (`azurerm_subnet`):
  - Created dynamically using a `for_each` loop based on `var.subnet_information` (from `terraform.tfvars`).
  - Subnets:
    - `websubnet01`: `10.0.0.0/24`
    - `websubnet02`: `10.0.1.0/24`
    - `websubnet03`: `10.0.2.0/24`
  - Linked to the virtual network `app-network` and resource group `app-grp`.

- **Network Interfaces** (`azurerm_network_interface`):
  - Count: Defined by `var.network_interface_count` (set to `3` in `terraform.tfvars`).
  - Names: `webinterface-1`, `webinterface-2`, `webinterface-3`.
  - Location: `EastUS`.
  - Resource Group: `app-grp`.
  - IP Configuration:
    - Subnet: Connected to `websubnet01`.
    - Private IP: Dynamically allocated.
    - Public IP: Linked to corresponding `azurerm_public_ip` resources.

- **Public IPs** (`azurerm_public_ip`):
  - Count: Matches `network_interface_count` (3).
  - Names: `webip01`, `webip02`, `webip03`.
  - Resource Group: `app-grp`.
  - Location: `EastUS`.
  - Allocation: Static (fixed IPs assigned).

- **Network Security Group (NSG)** (`azurerm_network_security_group`):
  - Name: `app-nsg`.
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

- **Subnet-NSG Association** (`azurerm_subnet_network_security_group_association`):
  - Associates the NSG (`app-nsg`) with all subnets created (`websubnet01`, `websubnet02`, `websubnet03`).

---

### 2. `terraform.tfvars` - Variable Values

This file assigns values to variables declared in `variables.tf`.

- **`network_interface_count`**:
  - Value: `3`
  - Meaning: Creates 3 network interfaces and corresponding public IPs.

- **`subnet_information`**:
  - Value: A map defining three subnets:
    - `websubnet01`: CIDR block `10.0.0.0/24`
    - `websubnet02`: CIDR block `10.0.1.0/24`
    - `websubnet03`: CIDR block `10.0.2.0/24`
  - Meaning: Specifies the subnet structure within the virtual network.

---

### 3. `terraform.tf` - Provider Configuration

This file configures Terraform and the Azure provider.

- **Terraform Block**:
  - Specifies the required provider:
    - `azurerm` (Azure Resource Manager)
    - Source: `hashicorp/azurerm`
    - Version: `4.25.0`

- **Provider Block** (`azurerm`):
  - Configures the Azure provider with credentials:
    - `client_id`: ``
    - `client_secret`: ``
    - `tenant_id`: ``
    - `subscription_id`: ``
  - Features: Empty block (default settings).

---

### 4. `variables.tf` - Variable Declarations

This file declares variables used in the configuration.

- **`network_interface_count`**:
  - Type: `number`
  - Description: Controls the number of network interfaces and public IPs.

- **`subnet_information`**:
  - Type: `map(object({cidrblock=string}))`
  - Meaning: A map where each key is a subnet name, and the value is an object containing a `cidrblock` (subnet address range).

---

### 5. `locals.tf` - Local Variables

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
- A resource group named `app-grp` in the `EastUS` region.
- A virtual network `app-network` with address space `10.0.0.0/16`.
- Three subnets: `websubnet01` (`10.0.0.0/24`), `websubnet02` (`10.0.1.0/24`), `websubnet03` (`10.0.2.0/24`).
- Three network interfaces (`webinterface-1`, `webinterface-2`, `webinterface-3`) in `websubnet01`, each with a static public IP (`webip01`, `webip02`, `webip03`).
- A network security group (`app-nsg`) allowing inbound RDP (port 3389), associated with all three subnets.

---

## How to Use

1. **Initialize Terraform**:
   ```bash
   terraform init