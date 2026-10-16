# 16 — Advanced Kubernetes

**Status:** Verified<br>
**Estimated time:** 34–46 hours<br>
**Prerequisites:** [15 — Infrastructure and production operations](../15-infrastructure-production-operations/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Infrastructure and production operations](../15-infrastructure-production-operations/README.md) · Next: [Production-readiness gate](../ASSESSMENT-GATES.md#gate-5--production-readiness)

## Why this matters

Kubernetes can be extended into a platform API, identity-aware network, policy
system, and fleet control plane. Every extension also adds privileged code,
failure modes, upgrade coupling, resource cost, and new operational ownership.
Senior practice is knowing both how these mechanisms work and when not to add one.

## Learning objectives

You can design and operate CRDs/controllers; explain reconciliation, status,
ownership, finalizers, webhooks, and version conversion; evaluate operators;
operate service-mesh identity and policy; reason about eBPF, autoscaling, and
policy engines; design multi-cluster fleets and failover; and defend ecosystem
choices with security, reliability, cost, recovery, and exit criteria.

## Contents

1. [Custom APIs and API evolution](01-custom-apis-evolution.md)
2. [Controllers and operators](02-controllers-operators.md)
3. [Service mesh, identity, and traffic](03-service-mesh-identity-traffic.md)
4. [eBPF, policy, and advanced scaling](04-ebpf-policy-scaling.md)
5. [Multi-cluster and ecosystem decisions](05-multicluster-ecosystem.md)
6. [Quick exercises](quick-exercises.md)
7. [Lab 1 — Build and recover a Python controller](labs/01-python-controller.md)
8. [Lab 2 — Enforce ambient mesh identity](labs/02-ambient-mesh.md)
9. [Lab 3 — Design and rehearse fleet failover](labs/03-fleet-failover.md)
10. [Final production-readiness assessment](production-readiness-assessment.md)
11. [Independent challenge](independent-challenge.md)
12. [Troubleshooting](troubleshooting.md)
13. [Interview questions](interview-questions.md)
14. [Knowledge check](quiz.md)
15. [References and videos](references.md)

## Recorded baseline

Python 3.12.15, Istio 1.31.2 ambient mode, kind 0.33.0, Kubernetes 1.36.4,
kubectl 1.36.1, and Docker Engine 29.7.2. The required labs share one disposable
three-node cluster. Tools and generated evidence belong under ignored
`tmp/module16`; no credentials, kubeconfigs, keys, or diagnostics are committed.

Runtime verification passed the Python unit test, server-side API validation,
two controller deployments and full reconcile tests, and two consecutive mesh
tests. Evidence covered least-privilege RBAC, current-generation status, owned
ConfigMaps, drift correction, genuine controller downtime and recovery,
finalizer cleanup, Istio ambient enrollment over HBONE, HTTP 200 for the allowed
ServiceAccount, and denial of a second identity. The cluster and temporary tools
were removed after validation.

## Completion

- [ ] **Explain:** trace custom API, controller, mesh, eBPF, and fleet mechanisms and limits.
- [ ] **Build:** reconcile a custom resource and enforce workload-identity traffic policy.
- [ ] **Diagnose:** recover controller, finalizer, mesh-policy, and fleet-drift failures from evidence.
- [ ] **Defend:** justify each extension against simpler alternatives, ownership, cost, and exit.
- [ ] Pass the [Production Readiness gate](../ASSESSMENT-GATES.md#gate-5--production-readiness).

## Continue

After this module, complete the [final production-readiness assessment](production-readiness-assessment.md)
and use the [curriculum index](../README.md) for targeted reassessment.
