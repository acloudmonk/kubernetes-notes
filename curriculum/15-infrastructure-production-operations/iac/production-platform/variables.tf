variable "environment" {
  description = "Environment governed by this topology model."
  type        = string
  default     = "production"

  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "environment must be staging or production."
  }
}

variable "availability_zones" {
  description = "Independent failure domains used by production nodes."
  type        = set(string)
  default     = ["zone-a", "zone-b", "zone-c"]

  validation {
    condition     = var.environment != "production" || length(var.availability_zones) >= 3
    error_message = "production requires at least three availability zones."
  }
}

variable "node_pools" {
  description = "Minimum/maximum nodes and planning inputs by ownership boundary."
  type = map(object({
    min_nodes       = number
    max_nodes       = number
    vcpu_per_node   = number
    hourly_cost_usd = number
  }))
  default = {
    system = { min_nodes = 3, max_nodes = 5, vcpu_per_node = 2, hourly_cost_usd = 0.12 }
    apps   = { min_nodes = 3, max_nodes = 12, vcpu_per_node = 4, hourly_cost_usd = 0.24 }
  }

  validation {
    condition = alltrue([
      for pool in values(var.node_pools) :
      pool.min_nodes >= 1 && pool.max_nodes >= pool.min_nodes &&
      pool.vcpu_per_node >= 1 && pool.hourly_cost_usd > 0
    ])
    error_message = "Every pool needs positive capacity/cost and max_nodes >= min_nodes."
  }

  validation {
    condition     = contains(keys(var.node_pools), "system") && contains(keys(var.node_pools), "apps")
    error_message = "Separate system and apps node pools are required."
  }
}

variable "reserved_capacity_percent" {
  description = "Capacity held for system overhead, rollout, and failure recovery."
  type        = number
  default     = 30

  validation {
    condition     = var.reserved_capacity_percent >= 20 && var.reserved_capacity_percent <= 50
    error_message = "Reserve between 20 and 50 percent for this learning model."
  }
}

variable "estimated_workload_request_vcpu" {
  description = "Aggregate steady-state workload CPU requests."
  type        = number
  default     = 6
}

variable "monthly_budget_usd" {
  description = "Illustrative monthly infrastructure budget; not a provider quote."
  type        = number
  default     = 3000
}
