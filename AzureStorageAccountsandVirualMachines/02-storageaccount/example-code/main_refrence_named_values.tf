# main.tf
# in this file we create a storage account a blob container however we will not hardcode the name
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id = ""
  client_secret = ""
  tenant_id = ""
  subscription_id = ""
}

resource "azurerm_resource_group" "app-grp" {
  name     = "app-grp"
  location = "North Europe"
}


resource "azurerm_storage_account" "appstore0154545454" {
  name                     = "appstore0154545454"
  resource_group_name      = azurerm_resource_group.appgrp.name
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_id    = azurerm_storage_account.appstore0154545454.id
}

resource "azurerm_storage_blob" "testfile" {
  name                   = "testfile.txt"                                         #name of file your want to upload
  storage_account_name   = azurerm_storage_account.appstore0154545454.name        #name of storage account
  storage_container_name = azurerm_storage_container.scripts.name           
  type                   = "Block"
  source                 = "testfile.txt"                                         #name of file your want to upload

}