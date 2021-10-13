variable resource_group_name {
  type        = string
  default     = ""
  description = "description"
}

variable eventhub_namespace_name {
  type        = string
  default     = ""
  description = "description"
}

variable eventhub_name {
  type        = string
  default     = ""
  description = "description"
}



variable location {
  type        = string
  default     = "eastus2"
  description = "Location"
}

variable sku {
  type        = string
  default     = "Standard"
  description = "description"
}

variable tags {
  type        = map
  default     = {}
  description = "description"
}

