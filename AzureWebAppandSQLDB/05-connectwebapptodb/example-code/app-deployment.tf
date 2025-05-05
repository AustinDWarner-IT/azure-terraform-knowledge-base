resource "azurerm_service_plan" "serviceplan" {
  for_each = var.webapp_environment.production.serviceplan
  name                = each.key
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.resource_location
  os_type             = each.value.os_type
  sku_name            = each.value.sku
}

resource "azurerm_windows_web_app" "webapp" {
  for_each = var.webapp_environment.production.serviceapp
  name                = each.key
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.resource_location
  
  service_plan_id     = azurerm_service_plan.serviceplan[each.value].id
  
  site_config {
    always_on=false
    application_stack {
      current_stack="dotnet"
      dotnet_version="v8.0"
  }
  }
  connection_string {
    name  = "AZURE_SQL_CONNECTIONSTRING"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver["${var.app_setup[0]}"].fully_qualified_domain_name},1433;Initial Catalog=${var.app_setup[1]};User Id=${azurerm_mssql_server.sqlserver["${var.app_setup[0]}"].administrator_login};Password='${azurerm_mssql_server.sqlserver["${var.app_setup[0]}"].administrator_login_password}';"
  }
}

resource "azurerm_mssql_firewall_rule" "allowservices" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sqlserver["${var.app_setup[0]}"].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0" 
}

resource "azurerm_app_service_source_control" "appservice_sourcecontrol" {
  app_id   = azurerm_windows_web_app.webapp["webapp5500040030"].id
  repo_url = "https://github.com/AustinDWarner-IT/webapp599909"
  branch   = "main"
  use_manual_integration = true  
}