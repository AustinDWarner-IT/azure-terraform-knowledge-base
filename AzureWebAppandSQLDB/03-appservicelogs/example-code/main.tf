resource "azurerm_resource_group" "appgrp" {
    name = "appgrp"
    location = local.resource_location
  
}

resource "azurerm_service_plan" "serviceplan" {
  for_each =          var.webapp_environment.production.serviceplan
  name              = each.key
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.resource_location
  os_type             = each.value.os_type
  sku_name            = each.value.sku
}


resource "azurerm_windows_web_app" "webapp" {
    for_each =          var.webapp_environment.production.serviceapp
  name                = each.key
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.resource_location
  service_plan_id     = azurerm_service_plan.serviceplan[each.value].id


  site_config {

    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v8.0"
    }
  }
  
    logs{
    detailed_error_messages = true
    http_logs {
      azure_blob_storage {
        retention_in_days = 7
        sas_url = "https://${azurerm_storage_account.appstorage8988989.name}.blob.core.windows.net/${azurerm_storage_container.weblogs.name}${data.azurerm_storage_account_blob_container_sas.accountsas.sas}"
      }
    }
  }

  tags=local.production_tags
}

