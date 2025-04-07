# Terraform Configuration Notes

This document outlines a Terraform setup for Azure infrastructure using multiple configuration files, local values, and key Azure resources.

---

## Project Structure
To keep the configuration modular and maintainable, we'll split the Terraform files as follows:
terraform_project/
├── main.tf              # Core configuration and provider setup
├── variables.tf         # Variable declarations
├── outputs.tf           # Output definitions
├── locals.tf            # Local values for reusability
├── network.tf           # Networking resources (VNet, Subnet, NSG, etc.)
└── interfaces.tf        # Network interfaces and related resources

text







---

## Key Resources and Concepts

### 1. Local Values (`locals.tf`)
Local values allow us to define reusable expressions or computed values within the configuration.  
[Reference: Terraform Types and Expressions](https://developer.hashicorp.com/terraform/language/expressions/types)

```
# locals.tf
locals {
  resource_group_name = "my-resource-group"
  location            = "East US"
  vnet_name           = "my-vnet"
  subnet_name         = "my-subnet"
  nsg_name            = "my-nsg"
  common_tags = {
    Environment = "Dev"
    Project     = "TerraformDemo"
  }
}
2. Virtual Network (network.tf)
Defines an Azure Virtual Network (VNet).

Reference: azurerm_virtual_network








# network.tf
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = local.resource_group_name
  location            = local.location
  address_space       = ["10.0.0.0/16"]

  tags = local.common_tags
}
3. Network Security Group (network.tf)
Defines a Network Security Group (NSG) to control traffic.

Reference: azurerm_network_security_group








# network.tf
resource "azurerm_network_security_group" "nsg" {
  name                = local.nsg_name
  resource_group_name = local.resource_group_name
  location            = local.location

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}
4. Subnet and NSG Association (network.tf)
Associates a subnet with an NSG.

Reference: azurerm_subnet_network_security_group_association








# network.tf
resource "azurerm_subnet" "subnet" {
  name                 = local.subnet_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
5. Network Interface (interfaces.tf)
Creates a network interface for a VM or other resource.

Reference: azurerm_network_interface








# interfaces.tf
resource "azurerm_network_interface" "nic" {
  name                = "my-nic"
  resource_group_name = local.resource_group_name
  location            = local.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.common_tags
}
6. Data Source: Public IP (interfaces.tf)
Fetches information about an existing public IP resource.

Reference: azurerm_public_ip (data source)








# interfaces.tf
data "azurerm_public_ip" "existing_ip" {
  name                = "my-existing-public-ip"
  resource_group_name = local.resource_group_name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.existing_ip.ip_address
}
Main Configuration (main.tf)
Sets up the Azure provider and ties everything together.








# main.tf
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
Variables (variables.tf)
Defines input variables (optional for customization).








# variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "my-resource-group"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
Outputs (outputs.tf)
Exposes useful information after deployment.








# outputs.tf
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}