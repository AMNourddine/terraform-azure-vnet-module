variable "resource_group_name" {
  description = "Name of the resource group where the resources will be created."
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be deployed."
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets to create. Key is the subnet name, value defines its config."
  type = map(object({
    address_prefixes = list(string)
    nsg_id            = optional(string)
  }))
  default = {}
}


variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}