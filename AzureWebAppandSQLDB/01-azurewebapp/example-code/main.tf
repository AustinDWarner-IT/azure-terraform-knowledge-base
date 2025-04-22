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
  lifecycle {
    ignore_changes = [ site_config ]
  }

  site_config {
    always_on = false
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v8.0"
    }
  }
  tags=local.production_tags
}