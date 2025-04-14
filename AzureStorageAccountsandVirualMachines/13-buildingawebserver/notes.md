# Azure Web Server with Terraform

Built a Windows web server on Azure using Terraform, complete with IIS configured via a custom script extension. Also moved the Terraform state to Azure Blob Storage for cloud-based management.

## Resources Created
- **Resource Group:** `app-grp` in `EastUS`
- **Networking:**
  - Virtual Network: `app-network` (CIDR: `10.0.0.0/16`)
  - Subnets: `websubnet01` (`10.0.0.0/24`), `websubnet02` (`10.0.1.0/24`), `websubnet03` (`10.0.2.0/24`)
  - Public IP: `webip01` (static)
  - Network Interface: `webinterface01`
  - NSG: `app-nsg` (allows RDP on 3389, HTTP on 80)
- **Virtual Machine:**
  - Name: `webvm01`
  - Size: `Standard_B2s`
  - OS: Windows Server 2016 Datacenter
  - Admin: `appadmin` with a password from Key Vault
- **Storage:**
  - Account: `appstore7895456` (Standard LRS, StorageV2)
  - Container: `scripts` (blob access)
  - Blob: `IIS.ps1` (PowerShell script for IIS setup)
- **Custom Script Extension:**
  - Name: `vmextension`
  - Downloads `IIS.ps1` from storage and runs it with PowerShell

## Key Changes
- **Custom Script Extension:** Added to the VM to automate IIS installation using `IIS.ps1` stored in Azure Blob Storage.
- **Cloud State:** Moved Terraform state to Azure Blob Storage (`tfstatestore789`, container `tfstate`) for remote management.

