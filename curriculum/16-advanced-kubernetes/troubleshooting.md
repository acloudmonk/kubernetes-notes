# Troubleshooting Advanced Kubernetes

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

| Symptom | Boundary/evidence | Safe correction |
|---|---|---|
| CR rejected | discovery, schema, CEL, admission response | fix contract; do not bypass validation |
| Status stale | generation, controller logs/queue, RBAC, API errors | restore controller and reconcile; do not edit optimistic status |
| Object stuck Terminating | deletion timestamp, finalizers, external cleanup | restore owning controller or complete verified cleanup before finalizer removal |
| Reconcile storm | events, retries, writes that change every loop | make level-based/idempotent; back off and stop needless status writes |
| Webhook blocks writes | endpoints, TLS, timeout, failure policy | use owned break glass; restore service or narrowly disable only under procedure |
| Mesh request denied | enrollment, source principal, policy scope, ztunnel/waypoint logs | correct identity/policy; do not broadly allow namespace traffic |
| Mesh request bypasses policy | protocol/port, enrollment, host/network path | identify actual data path and close unintended bypass |
| eBPF visibility missing | kernel support, attachment, maps, fallback path | restore supported hook/program and verify packets at boundaries |
| Fleet drift | source revision, cluster-specific overlays, apply authority | establish owner, compare rendered intent, reconcile in stages |
| Failover serves stale/duplicate data | replication lag, fencing, DNS, side effects | stop unsafe traffic, establish authority, restore/compensate by runbook |

Preserve timestamps and identities, reduce writers, stabilize impact, and verify
business behavior after repair. Avoid deleting finalizers, disabling admission,
or removing mesh policy before proving the failed boundary and blast radius.

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
