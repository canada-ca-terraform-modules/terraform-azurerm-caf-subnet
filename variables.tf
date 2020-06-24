variable "resource_group_name" {
  description = "(Required) Resource group name of the subnet to be created"    
}

variable "tags" {
  description = "(Required) Tags to be applied to the AKV to be created"
}

variable "address_prefixes" {
  description = "(Required) address_prefixes"  
}

variable "virtual_network_name" {
 description = "(Required) virtual_network_name"
}

variable "env" {
  description = "(Required) Name of the environment"
  type        = string
  default = ""
}

variable "group" {
  description = "(Required) Name of the group"
  type        = string
  default = ""
}

variable "project" {
  description = "(Required) Name of the project"
  type        = string
  default = ""
}

variable "subnetShortName" {
  description = "(Required) You can use a postfix to the name of the resource"
  type        = string
  default = ""
}
