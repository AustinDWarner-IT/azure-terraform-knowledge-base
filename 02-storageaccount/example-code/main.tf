# main.tf

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
  client_id = "fd1ade9e-0688-4fa1-9a62-8cf3574c3453"
  client_secret = "4~e8Q~CmEYb4nckundIukymAQm8RbvVR8ekqYbMC"
  tenant_id = "5e8289b1-4943-4144-9d06-e2eaa8e6eb02"
  subscription_id = "700cd528-e89f-4c0c-81b6-2196bb404191"
}

resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "North Europe"
}


resource "azurerm_storage_account" "appstore0154545454" {
  name                     = "appstore0154545454"
  resource_group_name      = "app-grp"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_id    = "/subscriptions/700cd528-e89f-4c0c-81b6-2196bb404191/resourceGroups/app-grp/providers/Microsoft.Storage/storageAccounts/appstore0154545454"

}

resource "azurerm_storage_blob" "testfile" {
  name                   = "testfile.txt"                           #name of file your want to upload
  storage_account_name   = "appstore0154545454"                     #name of storage account
  storage_container_name = "scripts"            
  type                   = "Block"
  source                 = "testfile.txt"                           #name of file your want to upload

}