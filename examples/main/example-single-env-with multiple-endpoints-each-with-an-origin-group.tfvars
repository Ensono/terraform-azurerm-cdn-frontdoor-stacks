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
