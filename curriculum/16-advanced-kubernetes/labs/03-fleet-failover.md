# Lab 3 — Design and Rehearse Fleet Failover

> **Module:** [16 — Advanced Kubernetes](../README.md) · Previous: [Lab 2 — Enforce ambient mesh identity](02-ambient-mesh.md) · Next: [Final production-readiness assessment](../production-readiness-assessment.md)

This required exercise is evidence-driven but does not require another cluster.
Create a failure dependency graph for CloudCart with primary and recovery
clusters. Include IaC/state, identity, keys, GitOps, policy, mesh trust, images,
PostgreSQL, RabbitMQ, object storage, observability, DNS/traffic, and operators.

Run a timed tabletop with these injects:

1. the primary API and GitOps controller become unreachable;
2. the newest database restore point is 12 minutes old;
3. the recovery region lacks one node-family quota;
4. DNS has a five-minute TTL; and
5. one external payment side effect must never be repeated.

Produce the declared incident time, decision log, achieved/violated RPO and RTO,
fencing decision, capacity change, restore order, traffic-shift criteria,
business validation, rollback/abort boundary, customer update, and postmortem
actions. Separate assumptions from tested facts.

Optional high-resource extension: create two single-node kind clusters with
separate kubeconfigs, apply the same signed/reviewed release identity, keep data
authority in only one, and script a context-safe traffic switch. This simulation
does not prove cloud networking, regional failure, storage replication, or DNS.

> **Module:** [16 — Advanced Kubernetes](../README.md) · Previous: [Lab 2 — Enforce ambient mesh identity](02-ambient-mesh.md) · Next: [Final production-readiness assessment](../production-readiness-assessment.md)
