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
  client_id         = "fd1ade9e-0688-4fa1-9a62-8cf3574c3453"
  client_secret     = "4~e8Q~CmEYb4nckundIukymAQm8RbvVR8ekqYbMC"
  tenant_id         = "5e8289b1-4943-4144-9d06-e2eaa8e6eb02"
  subscription_id   = "700cd528-e89f-4c0c-81b6-2196bb404191"
}