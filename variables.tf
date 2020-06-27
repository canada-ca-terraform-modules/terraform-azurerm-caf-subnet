variable "resource_group_name" {
  description = "(Required) Resource group name of the subnet to be created"
}

variable "address_prefixes" {
  description = "(Required) address_prefixes"
}

variable "virtual_network_name" {
  description = "(Required) virtual_network_name"
}

variable "subnetShortName" {
  description = "(Required) You can use a postfix to the name of the resource"
  type        = string
  default     = ""
}

variable "route_table" {
  description = "(Optional) Route table to associate to subnet"
  default     = null
}

variable "network_security_group" {
  description = "(Optional) NSG to associate to subnet"
  default     = null
}