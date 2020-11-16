terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = ">= 2.36.0"
  }
}

data "azurerm_client_config" "current" {}
