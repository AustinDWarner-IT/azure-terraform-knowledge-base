resource "azurerm_key_vault" "appvault700808" {
  name                        = "appvault700808"
  location                    = local.resource_location
  resource_group_name         = azurerm_resource_group.app_grp.name
  enabled_for_disk_encryption = true
  tenant_id                   = "5e8289b1-4943-4144-9d06-e2eaa8e6eb02"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  }