resource "azurerm_resource_group" "app_grp" {
  name     = "app-grp"
  location = local.resource_location
}


resource "azurerm_virtual_network" "app_network" {
  name                = var.app_environment.production.virtualnetworkname
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = [var.app_environment.production.virtualnetworkcidrblock]
}


resource "azurerm_subnet" "app_network_subnets" {
  for_each = var.app_environment.production.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.app_grp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = [each.value.cidrblock]
}


resource "azurerm_network_interface" "webinterfaces" {
  name                = var.app_environment.production.networkinterfacename
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app_grp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app_network_subnets["websubnet01"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.webip.id
  }
}
resource "azurerm_public_ip" "webip" {
  name                = var.app_environment.production.publicipaddressname



  resource_group_name = azurerm_resource_group.app_grp.name
  location            = azurerm_resource_group.app_grp.location
  allocation_method   = "Static"
}


resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app_grp.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "subnet_app_nsg" {
  for_each = azurerm_subnet.app_network_subnets
  subnet_id                 = azurerm_subnet.app_network_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}



resource "azurerm_windows_virtual_machine" "webvm" {
  name                = var.app_environment.production.virtualmachinename
  resource_group_name = azurerm_resource_group.app_grp.name
  location            = azurerm_resource_group.app_grp.location
  size                = "Standard_B2s"
  admin_username      = "appadmin"
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  vm_agent_platform_updates_enabled = true


  network_interface_ids = [
    azurerm_network_interface.webinterfaces.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}