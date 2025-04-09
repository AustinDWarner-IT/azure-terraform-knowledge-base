resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = local.resource_location
}

resource "azurerm_storage_account" "appstorageaccount" {
  name                     = local.storageaccountname
  resource_group_name      = azurerm_resource_group.appgrp.name
  location                 = local.resource_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "scripts" {
  for_each = toset([ "data","scripts", "logs" ])
  name                  = each.key
  storage_account_id  = azurerm_storage_account.appstorageaccount.id
}



# How do we get the output of the three containers
# We can use the splat operator

output "container-names" {
  value=azurerm_storage_container.scripts["data"].name
}
