# ADR 0014 — Adopt Kubernetes Extensions Only from Demonstrated Requirements

**Status:** Accepted for the learning architecture<br>
**Date:** 2026-10-16

## Context

Operators, service meshes, eBPF platforms, policy engines, autoscalers, and fleet
managers can solve real problems while adding privileged software, API contracts,
upgrade coupling, resource cost, and incident dependencies.

## Decision

CloudCart evaluates an extension only when a documented requirement cannot be
met more simply. Adoption requires measurable benefit, least privilege, failure
containment, supported versions, resource/cost budget, observability, upgrade
and recovery proof, an owner, and an exit path.

Module 16 uses a small Python controller and Istio ambient mesh as learning
implementations. They demonstrate mechanisms; they are not blanket production
adoption decisions. Multi-cluster remains unimplemented until geography,
regulation, isolation, or recovery evidence justifies fleet complexity.

## Consequences

The architecture avoids tool accumulation and makes ownership explicit. Teams
must spend time defining requirements and testing alternatives. A future
production operator, mesh, eBPF data plane, or fleet platform needs its own ADR.

## Verification

- Reconcile status, ownership, drift, finalizer cleanup, and controller outage.
- Verify mesh enrollment, workload identity, allowed and denied traffic.
- Complete the final readiness gate and a timed fleet-failover tabletop.
