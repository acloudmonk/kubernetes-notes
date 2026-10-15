# Troubleshooting

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Independent challenge](independent-challenge.md) · Next:
> [Interview questions](interview-questions.md)

## Evidence ladder

Start with the cheapest boundary checks and preserve the failing state:

```powershell
kubectl config current-context
kubectl cluster-info
kubectl auth can-i get pods -n architecture-lab
kubectl get deployment,replicaset,pod -n architecture-lab -o wide
kubectl get events -n architecture-lab --sort-by=.metadata.creationTimestamp
kubectl get nodes
```

Then inspect the relevant object as YAML or JSON. Avoid broad log collection
before identifying which component could own the transition.

## Symptom map

| Symptom | Likely boundary | Evidence before correction |
|---|---|---|
| TLS, timeout, or connection refused for every request | context, endpoint, network, API server | current context, cluster endpoint, request timeout, API container/endpoint health |
| `Unauthorized` | authentication | selected user mechanism and credential validity; never print tokens |
| `Forbidden` | authorization | identity, verb, resource, namespace, `kubectl auth can-i` |
| Admission timeout or rejection | admission webhook/policy | API error, webhook configuration, service endpoints, failure policy |
| Deployment generation newer than observed generation | controller has not processed current desired state | controller availability/logs, conditions, queue/API pressure |
| Pod has no node | scheduling | PodScheduled condition, Events, requests, taints, selectors, affinity, volumes |
| Pod has a node but no running container | kubelet/runtime/CNI/CSI/image | container waiting reason, Events, node conditions, kubelet/runtime evidence |
| Node Ready becomes Unknown | heartbeats/Lease stopped | Node conditions, Lease renew time, node reachability |
| Object remains Terminating | finalizer cleanup incomplete | deletion timestamp, finalizers, responsible controller, external resource state |

## Scenario: API unavailable but workloads remain

**Expected:** existing processes can run without constant API connectivity.

**Symptoms:** all `kubectl` operations time out, while the worker runtime still
shows containers.

**Investigate:** verify endpoint scope, API-server process/container, etcd
health, and admission dependencies. Do not restart every node.

**Diagnosis:** the management/reconciliation path is unavailable; this alone
does not imply every data-plane process stopped.

**Correction:** restore the failed control-plane dependency, then verify API
health, controllers, scheduling, and application convergence.

**Prevention:** appropriate API-server redundancy, etcd quorum and tested
restore, admission availability, monitoring, and an owned control-plane runbook.

## Scenario: worker silently disappears

**Expected:** Lease renewals and Node status remain current.

**Symptoms:** API is healthy, worker Ready becomes Unknown or False, and Pods
remain recorded against it during the initial grace period.

**Investigate:** compare Lease renewal time, Node conditions, network path,
kubelet state, runtime state, and controller-manager health.

**Correction:** recover or replace the node according to workload disruption
and storage safety. Verify new readiness and workload health, not only Node Ready.

**Prevention:** node health monitoring, redundant replicas, disruption budgets,
capacity headroom, controlled drains, and tested replacement automation.

## kind-specific failures

- If Docker is using Windows containers, switch Docker Desktop to the Linux engine.
- If `kind` is missing immediately after installation, open a new terminal so PATH refreshes.
- If image pull fails, distinguish registry connectivity from insufficient disk space.
- If creation partially fails, inspect `kind export logs`; treat the generated
  bundle as potentially sensitive and do not commit it.
- Before deleting, run `kind get clusters` and target only `architecture-lab`.

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Independent challenge](independent-challenge.md) · Next:
> [Interview questions](interview-questions.md)
