resource "azurerm_virtual_network" "app_network" {
  name                = var.app_environment.production.virtualnetworkname
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.appgrp.name
  address_space       = [var.app_environment.production.virtualnetworkcidrblock]
}

resource "azurerm_subnet" "app_network_subnets" {
  for_each = var.app_environment.production.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.appgrp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = [each.value.cidrblock]
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.appgrp.name

  
  dynamic security_rule {
    for_each = local.networksecuritygroup_rules
    content {
    name                       = "Allow-${security_rule.value.destination_port_range}"
    priority                   =  security_rule.value.priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_appnsg" {
  subnet_id                 = azurerm_subnet.app_network_subnets["dbsubnet01"].id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}