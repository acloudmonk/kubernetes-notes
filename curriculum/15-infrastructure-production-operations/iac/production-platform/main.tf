locals {
  minimum_nodes = sum([for pool in values(var.node_pools) : pool.min_nodes])
  minimum_vcpu  = sum([for pool in values(var.node_pools) : pool.min_nodes * pool.vcpu_per_node])
  usable_vcpu   = local.minimum_vcpu * (1 - var.reserved_capacity_percent / 100)
  node_cost_usd = sum([for pool in values(var.node_pools) : pool.min_nodes * pool.hourly_cost_usd * 730])

  # An explicit planning allowance, not a cloud-provider price promise.
  estimated_monthly_cost_usd = local.node_cost_usd + 150
}

check "steady_state_headroom" {
  assert {
    condition     = local.usable_vcpu >= var.estimated_workload_request_vcpu
    error_message = "Steady-state requests exceed capacity after the recovery reserve."
  }
}

check "budget_guardrail" {
  assert {
    condition     = local.estimated_monthly_cost_usd <= var.monthly_budget_usd
    error_message = "The illustrative minimum topology exceeds the declared budget."
  }
}
