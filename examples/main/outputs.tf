output "endpoint_mapping" {
  description = "Base configuration endpoints to module input mapping."
  value       = module.cdn_frontdoor_stacks.DEBUG_endpoint_mapping
  sensitive   = false
}

output "origin_group_mapping" {
  description = "Base configuration origin groups to module input mapping."
  value       = module.cdn_frontdoor_stacks.DEBUG_origin_group_mapping
  sensitive   = false
}

output "origin_mapping" {
  description = "Base configuration origins to module input mapping."
  value       = module.cdn_frontdoor_stacks.DEBUG_origin_mapping
  sensitive   = false
}

output "route_mapping" {
  description = "Base configuration routes to module input mapping."
  value       = module.cdn_frontdoor_stacks.DEBUG_route_mapping
  sensitive   = false
}

output "profile_name" {
  description = "The name of the CDN FrontDoor Profile."
  value       = module.cdn_frontdoor_stacks.profile_name
}

output "profile_id" {
  description = "The ID of the CDN FrontDoor Profile."
  value       = module.cdn_frontdoor_stacks.profile_id
  sensitive   = false
}

output "endpoints" {
  description = "CDN FrontDoor endpoints outputs."
  value       = module.cdn_frontdoor_stacks.endpoints
  sensitive   = false
}

output "origin_groups" {
  description = "CDN FrontDoor origin groups outputs."
  value       = module.cdn_frontdoor_stacks.origin_groups
  sensitive   = false
}

output "origins" {
  description = "CDN FrontDoor origins outputs."
  value       = module.cdn_frontdoor_stacks.origins
  sensitive   = false
}
