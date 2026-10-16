run "production_defaults" {
  command = plan

  assert {
    condition     = output.production_summary.availability_zone_count == 3
    error_message = "Production defaults must span three zones."
  }

  assert {
    condition     = output.production_summary.minimum_nodes == 6
    error_message = "System and application pools must provide six minimum nodes."
  }

  assert {
    condition     = output.production_summary.usable_vcpu_after_reserve >= 6
    error_message = "The default topology lacks its declared steady-state capacity."
  }
}

run "reject_two_zone_production" {
  command = plan

  variables {
    availability_zones = ["zone-a", "zone-b"]
  }

  expect_failures = [var.availability_zones]
}

run "reject_inverted_pool_range" {
  command = plan

  variables {
    node_pools = {
      system = { min_nodes = 3, max_nodes = 2, vcpu_per_node = 2, hourly_cost_usd = 0.12 }
      apps   = { min_nodes = 3, max_nodes = 12, vcpu_per_node = 4, hourly_cost_usd = 0.24 }
    }
  }

  expect_failures = [var.node_pools]
}
