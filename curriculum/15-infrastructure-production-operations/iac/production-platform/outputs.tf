output "production_summary" {
  description = "Reviewable planning evidence; it provisions no infrastructure."
  value = {
    environment                = var.environment
    availability_zone_count    = length(var.availability_zones)
    node_pool_names            = sort(keys(var.node_pools))
    minimum_nodes              = local.minimum_nodes
    minimum_vcpu               = local.minimum_vcpu
    usable_vcpu_after_reserve  = local.usable_vcpu
    estimated_monthly_cost_usd = local.estimated_monthly_cost_usd
  }
}
