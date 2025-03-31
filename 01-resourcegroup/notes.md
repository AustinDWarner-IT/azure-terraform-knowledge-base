az login
az account set --subscription "your subscription id"

terraform init
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "4.25.0"...
- Installing hashicorp/azurerm v4.25.0...
- Installed hashicorp/azurerm v4.25.0 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.




terraform plan -out main.tfplan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:    

  # azurerm_resource_group.appgrp will be created
  + resource "azurerm_resource_group" "appgrp" { 
      + id       = (known after apply)
      + location = "northeurope"
      + name     = "app-grp"
    }

Plan: 1 to add, 0 to change, 0 to destroy.



 ./terraform apply "main.tfplan"  
azurerm_resource_group.appgrp: Creating...
azurerm_resource_group.appgrp: Still creating... [10s elapsed]
azurerm_resource_group.appgrp: Creation complete after 11s [id=/subscriptions/700cd528-e89f-4c0c-81b6-2196bb404191/resourceGroups/app-grp]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.