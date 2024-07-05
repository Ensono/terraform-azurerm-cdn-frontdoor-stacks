
# // MANDATORY //
# naming and tagging
variable "name_company" {
  description = "Company name which can be used in naming and tagging of resources."
  type        = string
  sensitive   = false
}

variable "name_project" {
  description = "Company name which can be used in naming and tagging of resources."
  type        = string
  sensitive   = false
}

variable "name_environment" {
  description = "Environment name which can be used in naming and tagging of resources."
  type        = string
  sensitive   = false
}

# Azure
variable "azure_region" {
  description = "The Azure region (location) to target"
  type        = string
  sensitive   = false
}

# // OPTIONAL //
#naming and tagging
variable "name_component" {
  description = "Component name which can be used in naming and tagging of resources."
  type        = string
  default     = "gtm"
  sensitive   = false
}

variable "resource_tags" {
  description = "Resource tags to add."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# diagnostics settings
variable "afd_logs_destinations_ids" {
  type        = list(string)
  description = "List of destination resources IDs for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging."
  sensitive   = false
  default     = []
}

# debug
variable "enable_debug_output" {
  description = "Enable debug outputs."
  type        = bool
  default     = false
  sensitive   = false
}

# afd
variable "afd_sku_name" {
  description = "Specifies the SKU for this CDN FrontDoor Profile. Possible values include `Standard_AzureFrontDoor` and `Premium_AzureFrontDoor`."
  type        = string
  sensitive   = false
  default     = "Standard_AzureFrontDoor"
}

variable "afd_origin_response_timeout_seconds" {
  description = "Specifies the maximum origin response timeout in seconds. Possible values are between `16` and `240` seconds (inclusive)."
  type        = number
  sensitive   = false
  default     = 120
}

variable "afd_base_configuration" {
  description = "Specifies the base configuration which includes, multi-environment configuration with endpoints, origin groups, orgins, and routing rules."
  type        = map(any)
  sensitive   = false
  default     = {}
}
