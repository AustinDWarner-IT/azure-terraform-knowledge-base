resource "azurerm_subnet" "bastionsubnet" {
    name = "bastion-subnet"
    resource_group_name = azurerm_resource_group.app_grp.name
    virtual_network_name = var.app_environment.production.virtualnetworkname
    address_prefixes = [ "10.0.2.0/24" ]
  
}

resource "azurerm_public_ip" "bastionip" {
    name = "bastionip"
    resource_group_name = azurerm_resource_group.app_grp.name
    location = local.resource_location
    allocation_method = "Static"
    sku = "Standard"
  
}


resource "azurerm_bastion_host" "appbastion" {
  name                = "appbastion"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app_grp.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastionip.id
  }
}
