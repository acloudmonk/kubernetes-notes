# Managed Kubernetes Platform Design

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Infrastructure as code, state, and change](01-infrastructure-as-code-state.md) · Next: [Capacity, availability, tenancy, and cost](03-capacity-availability-cost.md)

A managed service normally owns some control-plane availability, patching, and
etcd operations. The customer still owns cluster configuration, identities,
network reachability, data plane, add-ons, workload policy, data recovery,
observability, cost, and application outcomes. Record the exact provider SLA,
version policy, backup boundary, and support escalation path.

## Landing zone before cluster

Define accounts/subscriptions/projects, regions and failure domains, DNS,
certificate and key ownership, IP capacity, private connectivity, egress,
firewalls, audit destinations, break-glass access, budgets, and log retention.
Cluster creation before these decisions merely hides platform dependencies.

Use private API endpoints where operating access supports them. Restrict public
endpoints, avoid flat trust, and plan Pod/Service CIDRs against peering,
on-premises, and future clusters. Identity federation and workload identity
avoid distributing long-lived cloud keys to Pods.

## Cluster and node-pool boundaries

Separate system and application capacity so critical DNS, networking, policy,
and telemetry components retain resources. Node pools encode architecture,
OS/runtime, availability zone, lifecycle, taints, labels, accelerator, purchase
model, and upgrade behavior. Labels or taints are placement controls, not strong
tenant isolation; node and cluster boundaries may be required for hostile code,
regulation, kernels, or independent failure domains.

Treat CNI, CSI, DNS, ingress/Gateway, autoscaling, policy, secret delivery,
observability, backup, and GitOps as versioned platform products. Each add-on
needs an owner, compatibility matrix, SLO, resource budget, upgrade order,
rollback or forward-fix plan, and telemetry.

## Fleet design

One larger cluster reduces duplicated control planes and platform add-ons but
increases blast radius and noisy-neighbor pressure. More clusters improve some
isolation and upgrade flexibility while multiplying policy, identity, fleet,
cost, and incident work. Choose from tenant risk, regulatory boundaries,
failure-domain requirements, regional latency, team autonomy, and operating
capacity—not a universal cluster-per-team rule.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Infrastructure as code, state, and change](01-infrastructure-as-code-state.md) · Next: [Capacity, availability, tenancy, and cost](03-capacity-availability-cost.md)
