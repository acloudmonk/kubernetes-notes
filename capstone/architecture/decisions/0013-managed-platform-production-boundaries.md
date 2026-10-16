# ADR 0013 — Managed Platform with Explicit Production Boundaries

**Status:** Accepted for the learning architecture<br>
**Date:** 2026-10-16

## Context

CloudCart needs a credible production target without committing this repository
to one billable cloud implementation. A managed Kubernetes control plane reduces
undifferentiated control-plane work, but network, identity, data plane, add-ons,
workloads, recovery, cost, and incidents still need explicit ownership.

## Decision

Model production as a managed, regional Kubernetes service with:

- at least three independent zones where the selected provider supports them;
- separate system and application node pools with measured recovery headroom;
- federated human and workload identity rather than committed static keys;
- private-by-default network paths and explicitly governed egress/API access;
- reviewed IaC with protected, locked, versioned state and one apply authority;
- GitOps ownership above the infrastructure boundary;
- independent recovery sets for infrastructure, desired state, keys, databases,
  queues, volumes, and external services; and
- owned SLO, capacity, upgrade, incident, and cost processes.

The executable Module 15 IaC is provider-free and estimates no authoritative
cloud price. A real implementation requires a provider-specific follow-up ADR.

## Consequences

The design keeps concepts portable and avoids credentials or charges in the
learning repo. It cannot validate provider quotas, IAM semantics, network
behavior, SLAs, or regional recovery. Those must be proven in authorized
non-production accounts before adoption.

## Verification

- Terraform tests reject inadequate zones and invalid node-pool ranges.
- A disposable two-worker lab proves spread, PDB-aware disruption, a business
  transaction during maintenance, and isolated logical restoration.
- The cumulative review traces supply chain, GitOps, observability, capacity,
  recovery, responsibility, and incident evidence.
