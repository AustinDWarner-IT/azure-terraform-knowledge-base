Azure Web Apps Logging with Terraform
Overview
This lesson focuses on configuring logging for Azure Web Apps using Terraform, emphasizing HTTP logs stored in Azure Blob Storage. The setup includes a resource group, App Service Plan, Windows-based web apps, and a storage account for logs, aimed at enabling diagnostics and troubleshooting.
Key Concepts

Azure Web Apps: A PaaS for hosting web applications with built-in logging capabilities.
App Service Logs: HTTP logs can be stored in Blob Storage for monitoring.
Terraform: Defines infrastructure, including logging and storage resources.
Storage Account: Hosts a container for log storage.
Shared Access Signature (SAS): Secures access to the storage container.

File Breakdown
1. terraform.tfvars

Purpose: Provides variable values.
Key Content:
webapp_environment: Configures a production environment with an S1 SKU service plan (serviceplan500090) and two web apps (webapp78888778, webapp99900999).
resource_tags: Tags with department = "Logistics", tier = "Tier2".
webapp_slot: Defines a staging slot for webapp78888778.


Significance: Specifies web apps for logging.

2. main.tf

Purpose: Defines core Azure resources.
Key Resources:
azurerm_resource_group: Creates appgrp in Central US.
azurerm_service_plan: Creates a service plan with S1 SKU via for_each.
azurerm_windows_web_app: Creates web apps with:
.NET 8.0 runtime.
HTTP logging to Blob Storage with a SAS URL.
Tags from local.production_tags.




Significance: Enables HTTP logging for diagnostics.

3. logging.tf

Purpose: Sets up storage for logs.
Key Resources:
azurerm_storage_account: Creates appstorage8988989 (Standard, LRS).
azurerm_storage_container: Creates weblogs container with blob access.
data.azurerm_storage_account_blob_container_sas: Generates a SAS with read, write, add permissions (valid 2025-04-22 to 2025-04-23).


Significance: Provides the storage backend for logs.

4. terraform.tf

Purpose: Configures Terraform provider and backend.
Key Content: Uses azurerm provider (4.25.0) with state stored in Azure (tfstatestore789).
Significance: Ensures secure state management.

5. locals.tf

Purpose: Defines reusable values.
Key Content: Sets resource_location = "Central US" and production_tags (e.g., production_code = "Logistics-Tier2").
Significance: Centralizes configuration.

6. variables.tf

Purpose: Declares variables.
Key Variables: webapp_environment, resource_tags, webapp_slot.
Significance: Supports flexible configuration.

App Service Logs Focus

Configuration: HTTP logs are enabled with detailed_error_messages = true, stored in the weblogs container with a 7-day retention.
Storage: Uses a Standard-tier storage account and blob container.
SAS: Secures log writing with a time-limited token.

Best Practices

Explicit Logging: Ensure http_logging_enabled = true in site_config.
SAS Rotation: Use short-lived SAS tokens and rotate regularly.
Network Rules: Allow App Service IPs in storage account firewall.
Monitoring: Integrate Azure Monitor for log analysis.

Conclusion
This configuration enables HTTP logging for Azure Web Apps, storing logs in Blob Storage for diagnostics. Explicitly enabling logging and securing storage access ensures effective monitoring and troubleshooting.
