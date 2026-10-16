# Lab 1 — Model and Test a Production Topology

> **Module:** [15 — Infrastructure and Production Operations](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Rehearse disruption and recovery](02-rehearse-disruption-recovery.md)

## Goal and safety

Validate a provider-free Terraform model for failure domains, node-pool
boundaries, recovery headroom, and a budget guardrail. It creates no remote or
billable resources and needs no credentials. Terraform state and data are
ignored and cleaned by the PowerShell script.

## Procedure

Use PowerShell with Terraform 1.14.8:

```powershell
./curriculum/15-infrastructure-production-operations/scripts/Test-Topology.ps1
```

Read the variables, locals, checks, outputs, and tests before running them.
Predict why two-zone production and an inverted node range fail. Then run a
speculative plan and inspect `production_summary`:

```powershell
$env:TF_DATA_DIR = "$PWD/tmp/module15/manual-terraform-data"
terraform -chdir=curriculum/15-infrastructure-production-operations/iac/production-platform init -backend=false
terraform -chdir=curriculum/15-infrastructure-production-operations/iac/production-platform plan
Remove-Item Env:TF_DATA_DIR
Remove-Item -LiteralPath tmp/module15/manual-terraform-data -Recurse -Force
```

The price is deliberately illustrative, not a provider quote. Extend the model
with storage, egress, observability, support, and a zone-loss scenario before
using it to review a real platform.

> **Module:** [15 — Infrastructure and Production Operations](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Rehearse disruption and recovery](02-rehearse-disruption-recovery.md)
