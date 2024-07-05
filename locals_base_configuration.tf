locals {
  /*
    creating a list of objects from var.afd_base_configuration
    aligned with Claranet front door endpoints input
  */
  endpoints = flatten([
    for env_key, env in var.afd_base_configuration : [
      for endpoint in env.endpoints : {
        name                 = endpoint.name
        prefix               = endpoint.prefix
        custom_resource_name = endpoint.custom_resource_name
        enabled              = endpoint.enabled
      }
    ]
  ])

  /*
    creating a list of objects from var.afd_base_configuration
    aligned with Claranet front door origin groups input
  */
  origin_groups = flatten([
    for env_key, env in var.afd_base_configuration : [
      for endpoint in env.endpoints : [
        for origin_group in endpoint.origin_groups : {
          name                                                      = origin_group.name
          custom_resource_name                                      = origin_group.custom_resource_name
          session_affinity_enabled                                  = origin_group.session_affinity_enabled
          restore_traffic_time_to_healed_or_new_endpoint_in_minutes = origin_group.restore_traffic_time_to_healed_or_new_endpoint_in_minutes

          health_probe = origin_group.health_probe == null ? null : {
            interval_in_seconds = origin_group.health_probe.interval_in_seconds
            path                = origin_group.health_probe.path
            protocol            = origin_group.health_probe.protocol
            request_type        = origin_group.health_probe.request_type
          }

          load_balancing = {
            additional_latency_in_milliseconds = origin_group.load_balancing.additional_latency_in_milliseconds
            sample_size                        = origin_group.load_balancing.sample_size
            successful_samples_required        = origin_group.load_balancing.successful_samples_required
          }
        }
      ]
    ]
  ])

  /*
    creating a list of objects from var.afd_base_configuration
    aligned with Claranet front door origins input
  */
  origins = flatten([
    for env_key, env in var.afd_base_configuration : [
      for endpoint in env.endpoints : [
        for origin_group in endpoint.origin_groups : [
          for origin in origin_group.origins : {
            name                           = origin.name
            custom_resource_name           = origin.custom_resource_name
            origin_group_name              = origin_group.name
            enabled                        = origin.enabled
            certificate_name_check_enabled = origin.certificate_name_check_enabled
            host_name                      = origin.host_name
            http_port                      = origin.http_port
            https_port                     = origin.https_port
            origin_host_header             = origin.origin_host_header
            priority                       = origin.priority
            weight                         = origin.weight

            private_link = origin.private_link == null ? null : {
              request_message        = origin.private_link.request_message
              target_type            = origin.private_link.target_type
              location               = origin.private_link.location
              private_link_target_id = origin.private_link.private_link_target_id
            }
          }
        ]
      ]
    ]
  ])

  /*
    creating a list of objects from var.afd_base_configuration
    aligned with Claranet front door routes input
  */
  routes = flatten([
    for env_key, env in var.afd_base_configuration : [
      for endpoint in env.endpoints : [
        for origin_group in endpoint.origin_groups : [
          for route in origin_group.routes : {
            name                 = route.name
            custom_resource_name = route.custom_resource_name
            endpoint_name        = endpoint.name
            origin_group_name    = origin_group.name
            origins_names        = origin_group.origins[*].name
            enabled              = route.enabled
            forwarding_protocol  = route.forwarding_protocol
            patterns_to_match    = route.patterns_to_match
            supported_protocols  = route.supported_protocols

            cache = route.cache == null ? null : {
              query_string_caching_behavior = route.cache.query_string_caching_behavior
              query_strings                 = route.cache.query_strings
              compression_enabled           = route.cache.compression_enabled
              content_types_to_compress     = route.cache.content_types_to_compress
            }

            custom_domains_names = route.custom_domains_names
            origin_path          = route.origin_path
            rule_sets_names      = route.rule_sets_names

            https_redirect_enabled = route.https_redirect_enabled
            link_to_default_domain = route.link_to_default_domain
          }
        ]
      ]
    ]
  ])
}
