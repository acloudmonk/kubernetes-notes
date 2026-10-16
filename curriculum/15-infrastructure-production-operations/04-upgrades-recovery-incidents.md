# Upgrades, Recovery, and Incident Operations

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Capacity, availability, tenancy, and cost](03-capacity-availability-cost.md) · Next: [Quick exercises](quick-exercises.md)

An upgrade is a compatibility program. Inventory APIs, admission webhooks,
operators, controllers, CSI/CNI, runtimes, nodes, clients, and applications.
Read release notes and provider constraints; scan removed APIs; rehearse with
production-like data and load; upgrade control plane, add-ons, and node pools in
the supported order; canary a new pool; drain within budgets; and verify SLOs,
events, capacity, and business transactions. A control-plane downgrade may be
unsupported, so rollback often means workload rollback or forward repair.

## Recovery design

RPO states acceptable data loss in time; RTO states acceptable time to useful
service. Map each dependency to backup consistency, retention, encryption keys,
immutability, region/account separation, restoration order, DNS/identity, and
validation. Kubernetes objects, Git, volumes, database backups, external queues,
and object stores are different recovery sets.

A completed backup is an input, not recovery evidence. Rehearse into isolation,
verify checksums and schema, exercise application invariants, measure achieved
RPO/RTO, prevent restored systems from sending real side effects, and clean up.
Document who declares disaster, who can access keys, and how traffic is moved.

## Incident command

Declare severity from impact and risk. Assign incident commander, operations,
communications, and subject experts. Keep a timestamped log of symptoms,
hypotheses, evidence, decisions, and changes. Stabilize first; preserve evidence;
make bounded reversible changes; communicate uncertainty; and define exit
criteria. Avoid multiple uncoordinated writers to infrastructure or GitOps.

## Learning after recovery

A blameless review explains conditions and control gaps, not merely the last
human action. Build a causal timeline; compare detection and response against
objectives; identify what helped and hindered; assign prioritized actions with
owners and dates; and verify completion. Track recurring incident classes and
whether prevention reduces customer impact.

Game days should start with a hypothesis and stop conditions. Inject the
smallest failure that tests the claim, retain normal observability, and never
surprise on-call or customers.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Capacity, availability, tenancy, and cost](03-capacity-availability-cost.md) · Next: [Quick exercises](quick-exercises.md)
