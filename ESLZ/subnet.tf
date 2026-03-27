terraform {
  required_version = ">= 1.9"
}

variable "subnets" {
  description = "Map of subnet configuration objects"
  type        = any
  default     = {}
}

module "subnets" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-subnet?ref=v3.2.0"
  for_each = var.subnets

  env             = var.env
  resource_group  = local.resource_groups[each.value.resource_group]
  virtual_network = local.virtual_networks[each.value.virtual_network]
  subnet          = each.value
}
