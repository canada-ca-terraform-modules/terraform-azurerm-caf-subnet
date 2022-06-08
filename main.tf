terraform {
  required_version = ">= 1.2.0"
  required_providers {
    azurerm = ">= 3.9.0"
  }
}

data "azurerm_client_config" "current" {}
