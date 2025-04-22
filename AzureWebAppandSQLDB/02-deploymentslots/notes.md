Azure Web Apps Deployment Slots with Terraform
Overview
This lesson focuses on configuring Azure Web Apps with deployment slots using Terraform. Deployment slots allow for staging and testing changes before swapping them into production, minimizing downtime and risk. The provided configuration sets up an Azure resource group, an App Service Plan, Windows-based web apps, and introduces a deployment slot for one web app.
Key Concepts

Azure Web Apps: A PaaS solution for hosting web applications, supporting .NET and other runtimes.
Deployment Slots: Isolated environments for testing or staging app changes, which can be swapped with production.
Terraform: Defines infrastructure as code, enabling repeatable and modular deployments.
App Service Plan: Specifies compute resources (e.g., SKU, OS) for web apps.
Tags: Metadata for resource organization and cost tracking.

File Breakdown
1. terraform.tfvars

Purpose: Provides values for Terraform variables.
Key Content:
webapp_environment: Defines a production environment with:
One App Service Plan (serviceplan500090) using a Standard S1 SKU and Windows OS.
Two web apps (webapp78888778, webapp99900999) linked to the service plan.


resource_tags: Sets tags (department = "Logistics", tier = "Tier2").
webapp_slot: Specifies a staging slot for webapp78888778 (["webapp78888778", "staging"]).


Significance: Configures a deployment slot for testing changes on a specific web app.

2. main.tf

Purpose: Defines Azure resources.
Key Resources:
azurerm_resource_group: Creates a resource group (appgrp) in Central US.
azurerm_service_plan: Creates an App Service Plan using for_each, with name, SKU (S1), and OS (Windows) from webapp_environment.
azurerm_windows_web_app: Creates web apps via for_each, with:
.NET 8.0 runtime (site_config.application_stack).
always_on = false (cost-saving for non-production tiers).
Tags from local.production_tags.
Ignores site_config changes in the lifecycle block.




Significance: Sets up the core infrastructure but does not yet implement the deployment slot (likely an oversight or pending addition).

3. terraform.tf

Purpose: Configures the Terraform provider and state backend.
Key Content:
Uses azurerm provider (version 4.25.0).
Stores state in an Azure storage account (tfstatestore789, container tfstate).
Provider authentication details are omitted for security.


Significance: Ensures secure state management and Azure integration.

4. locals.tf

Purpose: Defines reusable local values.
Key Content:
resource_location: Sets region to Central US.
production_tags: Combines department and tier into tags (e.g., production_code = "Logistics-Tier2").


Significance: Simplifies configuration with centralized values.

5. variables.tf

Purpose: Declares input variables with types.
Key Variables:
webapp_environment: Defines service plans (SKU, OS) and web apps.
resource_tags: Specifies department and tier for tagging.
webapp_slot: A list of strings to configure deployment slots.


Significance: Enables flexible slot configuration via variables.

Deployment Slots Focus

Configuration: The webapp_slot variable indicates a staging slot for webapp78888778, but main.tf lacks the azurerm_windows_web_app_slot resource to create it.
Purpose of Slots: Slots allow testing updates in a staging environment before swapping to production, reducing deployment risks.
SKU Requirement: The S1 SKU supports deployment slots (unlike the F1 tier), aligning with the configuration.
Next Steps: Add an azurerm_windows_web_app_slot resource in main.tf to create the staging slot, referencing webapp_slot.

Best Practices

Modularity: Variables and for_each enable scalable resource definitions.
State Management: Remote state storage supports team workflows.
Tagging: Tags improve resource tracking.
Slot Usage: Deployment slots enhance deployment reliability (once implemented).

Potential Improvements

Add Slot Resource: Include azurerm_windows_web_app_slot in main.tf to utilize webapp_slot.
Slot Swapping: Configure automation for slot swapping in CI/CD pipelines.
Monitoring: Add Application Insights for slot performance tracking.
Security: Store credentials in Azure Key Vault.

Conclusion
This configuration lays the groundwork for Azure Web Apps with deployment slots, though the slot implementation is incomplete. Adding the slot resource and leveraging the S1 SKU will enable robust staging and production workflows, aligning with best practices for reliable deployments.
