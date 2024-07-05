module "cdn_frontdoor" {
  #checkov:skip=CKV_TF_1:External module
  source  = "claranet/cdn-frontdoor/azurerm"
  version = "7.4.0"

  client_name = null
  stack       = null
  environment = null

  # naming
  name_prefix                = var.name_prefix
  resource_group_name        = var.name_resource_group
  cdn_frontdoor_profile_name = var.name_cdn_frontdoor_profile

  # profile configuration
  sku_name                 = var.afd_sku_name
  response_timeout_seconds = var.afd_origin_response_timeout_seconds
  logs_destinations_ids    = var.afd_logs_destinations_ids

  # base configuration
  endpoints     = local.endpoints
  origin_groups = local.origin_groups
  origins       = local.origins
  routes        = local.routes

  default_tags_enabled = false
  extra_tags           = var.resource_tags
}
