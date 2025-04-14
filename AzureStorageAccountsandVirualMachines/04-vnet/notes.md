📒 Notes on Terraform Networking and Configuration

🔗 Useful Links

Virtual Network (azurerm_virtual_network)

Terraform Expressions and Types

Network Interface (azurerm_network_interface)

Public IP Data Source (azurerm_public_ip)

Network Security Group (azurerm_network_security_group)

Subnet Network Security Group Association (azurerm_subnet_network_security_group_association)

📌 Using Local Values

Local values are a convenient way to avoid repetition and simplify Terraform configurations.

locals {
  resource_location = "EastUS"

  virtual_network = {
    name            = "app-network"
    address_prefixes = ["10.0.0.0/16"]
  }

  subnets = [
    {
      name            = "websubnet01"
      address_prefixes = ["10.0.0.0/24"]
    },
    {
      name            = "appsubnet01"
      address_prefixes = ["10.0.1.0/24"]
    }
  ]
}

💡 Benefits of Using Local Values

Reduces repetition

Improves readability

Centralizes configuration for easy modifications

📌 Splitting Terraform Configuration Files

Terraform supports splitting configurations into multiple files for better organization and scalability.

📁 Typical Structure

/example-code/
├── main.tf
├── locals.tf
├── network.tf
├── security.tf
├── outputs.tf
├── variables.tf

📌 Purpose of Each File

main.tf - Contains the core infrastructure definition (like resource groups and providers).

locals.tf - Defines local variables used across multiple files.

network.tf - Defines network components (VNets, Subnets, NICs, etc.)

security.tf - Defines security components (NSGs, Associations, Rules, etc.)

outputs.tf - Specifies outputs to be displayed after terraform apply.

variables.tf - Defines all variables used throughout the project.

📌 Best Practices

Use Local Values:

To keep configuration DRY (Don’t Repeat Yourself)

To centralize common configuration variables

Split Files By Purpose:

Separate files for networking, security, variables, etc., for better readability and modularization.

Consistent Naming Conventions:

Use consistent naming schemes for resources to avoid confusion.

Use terraform.tfvars for Variables:

Define variables separately for different environments (e.g., production.tfvars, dev.tfvars).

📌 Resources to Explore

The official AzureRM provider documentation is your best friend for specific resource configurations.

