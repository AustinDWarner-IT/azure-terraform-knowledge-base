data "azurerm_key_vault" "appvault2123246" {
  name                = "appvault2123246"
  resource_group_name = "security-grp"
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = var.admin_password
  key_vault_id = data.azurerm_key_vault.appvault2123246.id
}