
# // MANDATORY //
variable "name_resource_group" {
  description = "Resource group name."
  type        = string
  sensitive   = false
}

# // OPTIONAL //
# debug
variable "enable_debug_output" {
  description = "Enable debug outputs."
  type        = bool
  default     = false
  sensitive   = false
}


# naming and tagging
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  sensitive   = false
  default     = ""
}

variable "name_cdn_frontdoor_profile" {
  description = "Specifies the name of the FrontDoor Profile."
  type        = string
  sensitive   = false
  default     = null
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

# afd
variable "afd_sku_name" {
  description = "Specifies the SKU for this CDN FrontDoor Profile. Possible values include `Standard_AzureFrontDoor` and `Premium_AzureFrontDoor`."
  type        = string
  sensitive   = false
  default     = "Standard_AzureFrontDoor"

  validation {
    condition = contains([
      "Standard_AzureFrontDoor",
      "Premium_AzureFrontDoor"
    ], var.afd_sku_name)
    error_message = "Possibly values are 'Standard_AzureFrontDoor' or 'Premium_AzureFrontDoor'."
  }
}

variable "afd_origin_response_timeout_seconds" {
  description = "Specifies the maximum origin response timeout in seconds. Possible values are between `16` and `240` seconds (inclusive)."
  type        = number
  sensitive   = false
  default     = 120

  validation {
    condition = (
      var.afd_origin_response_timeout_seconds >= 16 &&
      var.afd_origin_response_timeout_seconds <= 120
    )
    error_message = "Possible values are between `16` and `240` seconds (inclusive)."
  }
}

variable "afd_base_configuration" {
  description = "Specifies the base configuration which includes, multi-environment configuration with endpoints, origin groups, orgins, and routing rules."
  type = map(object({
    endpoints = list(object({
      name                 = string
      prefix               = optional(string)
      custom_resource_name = optional(string)
      enabled              = optional(bool, true)

      origin_groups = list(object({
        name                                                      = string
        custom_resource_name                                      = optional(string)
        session_affinity_enabled                                  = optional(bool, true)
        restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 10)

        health_probe = optional(object({
          interval_in_seconds = number
          path                = string
          protocol            = string
          request_type        = string
        }))

        load_balancing = object({
          additional_latency_in_milliseconds = optional(number, 50)
          sample_size                        = optional(number, 4)
          successful_samples_required        = optional(number, 3)
        })

        origins = list(object({
          name                           = string
          custom_resource_name           = optional(string)
          enabled                        = optional(bool, true)
          certificate_name_check_enabled = optional(bool, true)

          host_name          = string
          http_port          = optional(number, 80)
          https_port         = optional(number, 443)
          origin_host_header = optional(string)
          priority           = optional(number, 1)
          weight             = optional(number, 1)

          private_link = optional(object({
            request_message        = optional(string)
            target_type            = optional(string)
            location               = string
            private_link_target_id = string
          }))
        }))

        routes = list(object({
          name                 = string
          custom_resource_name = optional(string)
          enabled              = optional(bool, true)
          forwarding_protocol  = optional(string, "HttpsOnly")
          patterns_to_match    = optional(list(string), ["/*"])
          supported_protocols  = optional(list(string), ["Http", "Https"])

          cache = optional(object({
            query_string_caching_behavior = optional(string, "IgnoreQueryString")
            query_strings                 = optional(list(string))
            compression_enabled           = optional(bool, false)
            content_types_to_compress     = optional(list(string))
          }))

          custom_domains_names = optional(list(string), [])
          origin_path          = optional(string, "/")
          rule_sets_names      = optional(list(string), [])

          https_redirect_enabled = optional(bool, true)
          link_to_default_domain = optional(bool, true)
        }))
      }))
    }))
  }))
  sensitive = false
  default   = {}
}
