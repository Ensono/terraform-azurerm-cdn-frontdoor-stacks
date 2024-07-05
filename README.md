# Azure CDN Front Door Stacks
This Stacks [Terraform composite module](https://developer.hashicorp.com/terraform/language/modules/develop/composition) is designed to create an [Azure CDN FrontDoor (Standard/Premium)](https://docs.microsoft.com/en-us/azure/frontdoor/standard-premium/tier-comparison) resource.

This module acts as an abstraction over a [third-party module](https://registry.terraform.io/modules/claranet/cdn-frontdoor/azurerm/7.4.0) from the Terraform registry. This decouples direct constraints between the calling root module and the third-party module. This decoupling has severval benefits:
* Hierarchical input model `afd_base_configuration` which describes the relationship between the different base configuration objects. This model supports many different configuration options:
    * multiple environments within a single Azure Front Door profile
    * single endpoint with multiple origin groups
    * multiple endpoints each with a single origin group
* Hierarchical input model mapping to the third-party module inputs means the third-party module could be replaced with no to minimal impact on the calling root module.
* If required, additional logic can be added to support advanced configuration.

## Roadmap
### Implemented
* Endpoints
* Origin Groups
* Origins
* Routes
* CDN

### Future
* Custom domains
* Custom wildcard domains
* Web Application Firewall (WAF)
* Rule sets
* CI

---

**NOTE**  
As each Stacks origin service and application are served from the same path (`/`), each client request to a service or application via Front Door must be over a different hostname. This means, as custom and wildcard domains haven't been implemented each service and application requires it's own endpoint in Front Door.

---

<!-- BEGIN_TF_DOCS -->
## Contributing
This repository uses the [pre-commit](https://pre-commit.com/) git hook framework which can update and format some files enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage
Examples can be found at the bottom taken from the `examples` directory.


## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| cdn\_frontdoor | claranet/cdn-frontdoor/azurerm | 7.4.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| afd\_base\_configuration | Specifies the base configuration which includes, multi-environment configuration with endpoints, origin groups, orgins, and routing rules. | <pre>map(object({<br>    endpoints = list(object({<br>      name                 = string<br>      prefix               = optional(string)<br>      custom_resource_name = optional(string)<br>      enabled              = optional(bool, true)<br><br>      origin_groups = list(object({<br>        name                                                      = string<br>        custom_resource_name                                      = optional(string)<br>        session_affinity_enabled                                  = optional(bool, true)<br>        restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 10)<br><br>        health_probe = optional(object({<br>          interval_in_seconds = number<br>          path                = string<br>          protocol            = string<br>          request_type        = string<br>        }))<br><br>        load_balancing = object({<br>          additional_latency_in_milliseconds = optional(number, 50)<br>          sample_size                        = optional(number, 4)<br>          successful_samples_required        = optional(number, 3)<br>        })<br><br>        origins = list(object({<br>          name                           = string<br>          custom_resource_name           = optional(string)<br>          enabled                        = optional(bool, true)<br>          certificate_name_check_enabled = optional(bool, true)<br><br>          host_name          = string<br>          http_port          = optional(number, 80)<br>          https_port         = optional(number, 443)<br>          origin_host_header = optional(string)<br>          priority           = optional(number, 1)<br>          weight             = optional(number, 1)<br><br>          private_link = optional(object({<br>            request_message        = optional(string)<br>            target_type            = optional(string)<br>            location               = string<br>            private_link_target_id = string<br>          }))<br>        }))<br><br>        routes = list(object({<br>          name                 = string<br>          custom_resource_name = optional(string)<br>          enabled              = optional(bool, true)<br>          forwarding_protocol  = optional(string, "HttpsOnly")<br>          patterns_to_match    = optional(list(string), ["/*"])<br>          supported_protocols  = optional(list(string), ["Http", "Https"])<br><br>          cache = optional(object({<br>            query_string_caching_behavior = optional(string, "IgnoreQueryString")<br>            query_strings                 = optional(list(string))<br>            compression_enabled           = optional(bool, false)<br>            content_types_to_compress     = optional(list(string))<br>          }))<br><br>          custom_domains_names = optional(list(string), [])<br>          origin_path          = optional(string, "/")<br>          rule_sets_names      = optional(list(string), [])<br><br>          https_redirect_enabled = optional(bool, true)<br>          link_to_default_domain = optional(bool, true)<br>        }))<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| afd\_logs\_destinations\_ids | List of destination resources IDs for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | `[]` | no |
| afd\_origin\_response\_timeout\_seconds | Specifies the maximum origin response timeout in seconds. Possible values are between `16` and `240` seconds (inclusive). | `number` | `120` | no |
| afd\_sku\_name | Specifies the SKU for this CDN FrontDoor Profile. Possible values include `Standard_AzureFrontDoor` and `Premium_AzureFrontDoor`. | `string` | `"Standard_AzureFrontDoor"` | no |
| enable\_debug\_output | Enable debug outputs. | `bool` | `false` | no |
| name\_cdn\_frontdoor\_profile | Specifies the name of the FrontDoor Profile. | `string` | `null` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_resource\_group | Resource group name. | `string` | n/a | yes |
| resource\_tags | Resource tags to add. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| DEBUG\_endpoint\_mapping | DEBUG: base configuration endpoints to module input mapping. |
| DEBUG\_origin\_group\_mapping | DEBUG: base configuration origin groups to module input mapping. |
| DEBUG\_origin\_mapping | DEBUG: base configuration origins to module input mapping. |
| DEBUG\_route\_mapping | DEBUG: base configuration routes to module input mapping. |
| endpoints | CDN FrontDoor endpoints outputs. |
| origin\_groups | CDN FrontDoor origin groups outputs. |
| origins | CDN FrontDoor origins outputs. |
| profile\_id | The ID of the CDN FrontDoor Profile. |
| profile\_name | The name of the CDN FrontDoor Profile. |

## Examples
There are three common configurations which are desribed below:
### Single Environment and Endpoint with Multiple Origin Groups

```hcl
afd_base_configuration = {
  "dev" = {
    endpoints = [
      {
        name = "dev"
        origin_groups = [
          {
            name = "dev-frontend"
            health_probe = {
              interval_in_seconds = 250
              path                = "/"
              protocol            = "Https"
              request_type        = "HEAD"
            }
            load_balancing = {}
            origins = [
              {
                name      = "dev-frontend-uks"
                host_name = "dev-frontend-uks.stacks.ensono.com"
              },
              {
                name      = "dev-frontend-ukw"
                host_name = "dev-frontend-ukw.stacks.ensono.com"
              }
            ]
            routes = [
              {
                name = "dev-frontend-01"
              }
            ]
          },
          {
            name = "dev-backend"
            health_probe = {
              interval_in_seconds = 250
              path                = "/healthcheck"
              protocol            = "Https"
              request_type        = "HEAD"
            }
            load_balancing = {}
            origins = [
              {
                name      = "dev-backend-uks"
                host_name = "dev-backend-uks.stacks.ensono.com"
              },
              {
                name      = "dev-backend-ukw"
                host_name = "dev-backend-ukw.stacks.ensono.com"
              }
            ]
            routes = [
              {
                name = "dev-backend-01"
                patterns_to_match = [
                  "/api/*"
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}
```

### Single Environment with multiple Endpoints each with an Origin Group
```hcl
afd_base_configuration = {
  "dev" = {
    endpoints = [
      {
        name = "dev-frontend"
        origin_groups = [
          {
            name = "dev-frontend"
            health_probe = {
              interval_in_seconds = 250
              path                = "/"
              protocol            = "Https"
              request_type        = "HEAD"
            }
            load_balancing = {}
            origins = [
              {
                name      = "dev-frontend-uks"
                host_name = "dev-frontend-uks.stacks.ensono.com"
              },
              {
                name      = "dev-frontend-ukw"
                host_name = "dev-frontend-ukw.stacks.ensono.com"
              }
            ]
            routes = [
              {
                name = "dev-frontend-01"
              }
            ]
          }
        ]
      },
      {
        name = "dev-backend"
        origin_groups = [
          {
            name = "dev-backend"
            health_probe = {
              interval_in_seconds = 250
              path                = "/healthcheck"
              protocol            = "Https"
              request_type        = "HEAD"
            }
            load_balancing = {}
            origins = [
              {
                name      = "dev-backend-uks"
                host_name = "dev-backend-uks.stacks.ensono.com"
              },
              {
                name      = "dev-backend-ukw"
                host_name = "dev-backend-ukw.stacks.ensono.com"
              }
            ]
            routes = [
              {
                name = "dev-backend-01"
                patterns_to_match = [
                  "/api/*"
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}
```

### Multiple Environments with a Single Endpoint with Multiple Origin Groups
```hcl
afd_base_configuration = {
  "dev" = {
    endpoints = [
      {
        name = "dev"
        origin_groups = [
          {
            name = "dev-frontend"
            health_probe = {
              interval_in_seconds = 250
              path                = "/"
              protocol            = "Https"
              request_type        = "HEAD"
            }
            load_balancing = {}
            origins = [
              {
                name      = "dev-frontend-uks"
                host_name = "dev-frontend-uks.stacks.ensono.com"
              },
              {
                name      = "dev-frontend-ukw"
                host_name = "dev-frontend-ukw.stacks.ensono.com"
              }
            ]
            routes = [
              {
                name = "dev-frontend-01"
              }
            ]
          },
          {
            name = "dev-backend"
            health_probe = {
              interval_in_seconds = 250
              path                = "/healthcheck"
              protocol            = "Https"
              request_type        = "HEAD"
            }
            load_balancing = {}
            origins = [
              {
                name      = "dev-backend-uks"
                host_name = "dev-backend-uks.stacks.ensono.com"
              },
              {
                name      = "dev-backend-ukw"
                host_name = "dev-backend-ukw.stacks.ensono.com"
              }
            ]
            routes = [
              {
                name = "dev-backend-01"
                patterns_to_match = [
                  "/api/*"
                ]
              }
            ]
          }
        ]
      }
    ]
  },
  "test" = {
    endpoints = [
      {
        name = "test"
        origin_groups = [
          {
            name = "test-frontend"
            health_probe = {
              interval_in_seconds = 250
              path                = "/"
              protocol            = "Https"
              request_type        = "HEAD"
            }
            load_balancing = {}
            origins = [
              {
                name      = "test-frontend-uks"
                host_name = "test-frontend-uks.stacks.ensono.com"
              },
              {
                name      = "test-frontend-ukw"
                host_name = "test-frontend-ukw.stacks.ensono.com"
              }
            ]
            routes = [
              {
                name = "test-frontend-01"
              }
            ]
          },
          {
            name = "test-backend"
            health_probe = {
              interval_in_seconds = 250
              path                = "/healthcheck"
              protocol            = "Https"
              request_type        = "HEAD"
            }
            load_balancing = {}
            origins = [
              {
                name      = "test-backend-uks"
                host_name = "test-backend-uks.stacks.ensono.com"
              },
              {
                name      = "test-backend-ukw"
                host_name = "test-backend-ukw.stacks.ensono.com"
              }
            ]
            routes = [
              {
                name = "test-backend-01"
                patterns_to_match = [
                  "/api/*"
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}
```
<!-- END_TF_DOCS -->
