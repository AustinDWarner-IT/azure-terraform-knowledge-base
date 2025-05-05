resource "azurerm_resource_group" "appgrp" {
  name = "app-grp"
  location = local.resource_location
  
}