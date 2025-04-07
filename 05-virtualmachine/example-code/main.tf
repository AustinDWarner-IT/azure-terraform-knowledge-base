



resource "azurerm_resource_group" "app_grp" {
  name     = "app-grp"
  location = local.resource_location
}

resource "azurerm_virtual_network" "app_network" {
  name                = local.virtual_network.name
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = local.virtual_network.address_prefixes
}

resource "azurerm_subnet" "websubnet01" {
  name                 = local.subnets[0].name
  resource_group_name  = azurerm_resource_group.app_grp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = local.subnets[0].address_prefixes
}

resource "azurerm_subnet" "appsubnet01" {
  name                 = local.subnets[1].name
  resource_group_name  = azurerm_resource_group.app_grp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = local.subnets[1].address_prefixes
}

resource "azurerm_network_interface" "webinterface01" {
  name                = "webinterface01"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.websubnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.webip01.id
  }
}

resource "azurerm_public_ip" "webip01" {
  name                    = "webip01"
  location                = azurerm_resource_group.app_grp.location
  resource_group_name     = azurerm_resource_group.app_grp.name
  allocation_method       = "Static"
}


resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg"
  location            = azurerm_resource_group.app_grp.location
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

resource "azurerm_subnet_network_security_group_association" "websubnet01_appnsg" {
  subnet_id                 = azurerm_subnet.websubnet01.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "appsubnet01_appnsg" {
  subnet_id                 = azurerm_subnet.appsubnet01.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}



output "webinterface01_id" {
  value = azurerm_subnet.websubnet01
  
}

resource "azurerm_windows_virtual_machine" "webvm01" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.app_grp.name
  location            = azurerm_resource_group.app_grp.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  vm_agent_platform_updates_enabled = true
  network_interface_ids = [
    azurerm_network_interface.webinterface01.id,
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




resource "azurerm_managed_disk" "datadisk01" {
  name                 = "datadisk01"
  location             = azurerm_resource_group.app_grp.location
  resource_group_name  = azurerm_resource_group.app_grp.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "4"
}


resource "azurerm_virtual_machine_data_disk_attachment" "datadisk01" {
  managed_disk_id = azurerm_managed_disk.datadisk01.id
  virtual_machine_id = azurerm_windows_virtual_machine.webvm01.id
  lun = "0"
  caching = ReadWrite
  
}