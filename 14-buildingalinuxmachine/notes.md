# Terraform Configuration: Deploying a Linux VM with NGINX and Custom HTML

This document explains a Terraform configuration for deploying a Linux virtual machine in Azure, emphasizing the setup of an NGINX web server and the process of loading a custom `Default.html` file. The configuration includes virtual networking, security, and custom scripting components.

## Overview

The Terraform scripts deploy an Azure infrastructure with:
- A resource group (`app-grp`) and virtual network.
- Subnets for web and app tiers.
- A Linux VM (`appvm01`) in the app subnet, running Ubuntu with NGINX.
- A Windows VM (`webvm01`) in the web subnet.
- A Key Vault for secure password storage.
- Storage accounts and scripts for custom configurations.
- File provisioning to load a custom `Default.html` file on the Linux VM.

The focus here is on the Linux VM, NGINX setup, and how the `.html` file is deployed.

## Linux Virtual Machine Configuration

The Linux VM is defined in `main.tf` under the `azurerm_linux_virtual_machine` resource named `apvm01`.

### Key Configuration Details
- **Name**: `appvm01`
- **OS**: Ubuntu Server 22.04 LTS (`Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest`)
- **Size**: `Standard_B1s`
- **Location**: `EastUS` (defined in `locals.tf`)
- **Admin Credentials**:
  - Username: `linuxadmin`
  - Password: Sourced from `var.admin_password` (stored securely in Azure Key Vault via `security.tf`)
  - Password authentication enabled (`disable_password_authentication = false`)
- **Network**:
  - Attached to `appsubnet01` via a network interface (`azurerm_network_interface.appinterfaces`).
  - Assigned a public IP (`azurerm_public_ip.appip`) for SSH and HTTP access.
- **Disk**:
  - Standard locally redundant storage (`Standard_LRS`) with read-write caching.
- **Custom Data**:
  - Uses a `cloud-init` script (`cloudinit`) to install NGINX during VM initialization.

### Cloud-Init Setup
The `cloudinit` file, referenced in `main.tf` via `data.local_file.cloudinit`, contains:

```yaml
#cloud-config
package_upgrade: true
packages:
  - nginx