
resource "azurerm_storage_account" "appstorage8988989" {
  name                     = "appstorage8988989"
  resource_group_name      = azurerm_resource_group.appgrp.name
  location                 = azurerm_resource_group.appgrp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
}

resource "azurerm_storage_container" "weblogs" {
    name = "weblogs"
    storage_account_id = azurerm_storage_account.appstorage8988989.id
    container_access_type = "blob"
}

data "azurerm_storage_account_blob_container_sas" "accountsas" {
  connection_string = azurerm_storage_account.appstorage8988989.primary_connection_string
  container_name = azurerm_storage_container.weblogs.name
  https_only        = true

  start = "2025-4-22"
  expiry = "2025-4-23"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = false
  }
}
