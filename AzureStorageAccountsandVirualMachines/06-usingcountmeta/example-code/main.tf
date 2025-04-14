resource "azurerm_resource_group" "app_grp" {
  name     = "app-grp"
  location = local.resource_location
}

resource "azurerm_storage_account" "appstorageaccount" {
  count = 3                                                                   # we use count to create 3 storage accounts at the same time 
  name = "${count.index}appstore40000056"
  resource_group_name = azurerm_resource_group.app_grp.name                   
  location = azurerm_resource_group.app_grp.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  
}
