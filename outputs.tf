output "DEBUG_endpoint_mapping" {
  description = "DEBUG: base configuration endpoints to module input mapping."
  value       = var.enable_debug_output ? local.endpoints : null
  sensitive   = false
}

output "DEBUG_origin_group_mapping" {
  description = "DEBUG: base configuration origin groups to module input mapping."
  value       = var.enable_debug_output ? local.origin_groups : null
  sensitive   = false
}

output "DEBUG_origin_mapping" {
  description = "DEBUG: base configuration origins to module input mapping."
  value       = var.enable_debug_output ? local.origins : null
  sensitive   = false
}

output "DEBUG_route_mapping" {
  description = "DEBUG: base configuration routes to module input mapping."
  value       = var.enable_debug_output ? local.routes : null
  sensitive   = false
}

output "profile_name" {
  description = "The name of the CDN FrontDoor Profile."
  value       = module.cdn_frontdoor.profile_name
}

output "profile_id" {
  description = "The ID of the CDN FrontDoor Profile."
  value       = module.cdn_frontdoor.profile_id
  sensitive   = false
}

output "endpoints" {
  description = "CDN FrontDoor endpoints outputs."
  value       = module.cdn_frontdoor.endpoints
  sensitive   = false
}

output "origin_groups" {
  description = "CDN FrontDoor origin groups outputs."
  value       = module.cdn_frontdoor.origin_groups
  sensitive   = false
}

output "origins" {
  description = "CDN FrontDoor origins outputs."
  value       = module.cdn_frontdoor.origins
  sensitive   = false
}
