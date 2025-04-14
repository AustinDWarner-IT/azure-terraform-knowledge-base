resource "azurerm_resource_group" "app_grp" {
  name     = "app-grp"
  location = local.resource_location
}


