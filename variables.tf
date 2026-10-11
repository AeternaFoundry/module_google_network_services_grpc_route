variable "network_services_grpc_routes" {
  description = <<EOT
Map of network_services_grpc_routes, attributes below
Required:
    - hostnames
    - name
    - rules (block):
        - action (optional, block):
            - destinations (optional, block):
                - service_name (optional)
                - weight (optional)
            - fault_injection_policy (optional, block):
                - abort (optional, block):
                    - http_status (optional)
                    - percentage (optional)
                - delay (optional, block):
                    - fixed_delay (optional)
                    - percentage (optional)
            - retry_policy (optional, block):
                - num_retries (optional)
                - retry_conditions (optional)
            - timeout (optional)
        - matches (optional, block):
            - headers (optional, block):
                - key (required)
                - type (optional)
                - value (required)
            - method (optional, block):
                - case_sensitive (optional)
                - grpc_method (required)
                - grpc_service (required)
Optional:
    - deletion_policy
    - description
    - gateways
    - labels
    - location
    - meshes
    - project
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    hostnames       = list(string)
    name            = string
    deletion_policy = optional(string)
    description     = optional(string)
    gateways        = optional(list(string))
    labels          = optional(map(string))
    location        = optional(string)
    meshes          = optional(list(string))
    project         = optional(string)
    rules = list(object({
      action = optional(object({
        destinations = optional(list(object({
          service_name = optional(string)
          weight       = optional(number)
        })))
        fault_injection_policy = optional(object({
          abort = optional(object({
            http_status = optional(number)
            percentage  = optional(number)
          }))
          delay = optional(object({
            fixed_delay = optional(string)
            percentage  = optional(number)
          }))
        }))
        retry_policy = optional(object({
          num_retries      = optional(number)
          retry_conditions = optional(list(string))
        }))
        timeout = optional(string)
      }))
      matches = optional(list(object({
        headers = optional(list(object({
          key   = string
          type  = optional(string)
          value = string
        })))
        method = optional(object({
          case_sensitive = optional(bool)
          grpc_method    = string
          grpc_service   = string
        }))
      })))
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.network_services_grpc_routes : (
        length(v.rules) >= 1
      )
    ])
    error_message = "Each rules list must contain at least 1 items"
  }
  # Note: 3 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

