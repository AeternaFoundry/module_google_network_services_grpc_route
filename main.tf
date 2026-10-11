resource "google_network_services_grpc_route" "network_services_grpc_routes" {
  for_each = var.network_services_grpc_routes

  hostnames       = each.value.hostnames
  name            = each.value.name
  deletion_policy = each.value.deletion_policy
  description     = each.value.description
  gateways        = each.value.gateways
  labels          = each.value.labels
  location        = each.value.location
  meshes          = each.value.meshes
  project         = each.value.project

  dynamic "rules" {
    for_each = each.value.rules
    content {
      dynamic "action" {
        for_each = rules.value.action != null ? [rules.value.action] : []
        content {
          dynamic "destinations" {
            for_each = action.value.destinations != null ? action.value.destinations : []
            content {
              service_name = destinations.value.service_name
              weight       = destinations.value.weight
            }
          }
          dynamic "fault_injection_policy" {
            for_each = action.value.fault_injection_policy != null ? [action.value.fault_injection_policy] : []
            content {
              dynamic "abort" {
                for_each = fault_injection_policy.value.abort != null ? [fault_injection_policy.value.abort] : []
                content {
                  http_status = abort.value.http_status
                  percentage  = abort.value.percentage
                }
              }
              dynamic "delay" {
                for_each = fault_injection_policy.value.delay != null ? [fault_injection_policy.value.delay] : []
                content {
                  fixed_delay = delay.value.fixed_delay
                  percentage  = delay.value.percentage
                }
              }
            }
          }
          dynamic "retry_policy" {
            for_each = action.value.retry_policy != null ? [action.value.retry_policy] : []
            content {
              num_retries      = retry_policy.value.num_retries
              retry_conditions = retry_policy.value.retry_conditions
            }
          }
          timeout = action.value.timeout
        }
      }
      dynamic "matches" {
        for_each = rules.value.matches != null ? rules.value.matches : []
        content {
          dynamic "headers" {
            for_each = matches.value.headers != null ? matches.value.headers : []
            content {
              key   = headers.value.key
              type  = headers.value.type
              value = headers.value.value
            }
          }
          dynamic "method" {
            for_each = matches.value.method != null ? [matches.value.method] : []
            content {
              case_sensitive = method.value.case_sensitive
              grpc_method    = method.value.grpc_method
              grpc_service   = method.value.grpc_service
            }
          }
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

