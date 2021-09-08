terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = ">= 2.36.0"
  }
}

data "azurerm_client_config" "current" {}
