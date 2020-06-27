variable "resource_group" {
  description = "(Required) Resource group object of the subnet to be created"
}

variable "address_prefixes" {
  description = "(Required) address_prefixes"
}

variable "virtual_network" {
  description = "(Required) virtual_network object"
}

variable "userDefinedString" {
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