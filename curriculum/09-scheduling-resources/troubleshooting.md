# Troubleshooting Scheduling and Resources

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

Start with the Pod object and ordered events. Preserve the symptom before
changing requests, labels, taints, replicas, or PDBs.

| Symptom | Separate these causes | Evidence |
|---|---|---|
| Pending, no node | insufficient requested resource; required affinity; taint; topology spread; host port; PVC topology; quota | `PodScheduled` condition, scheduler events, `spec.nodeName`, node labels/taints/allocatable, PVC events |
| Scheduled, not running | image pull; mount; sandbox/CNI; init container; admission on kubelet | container waiting reasons, init status, events, kubelet/runtime evidence |
| Slow under CPU load | CPU throttling; application lock; downstream latency; insufficient replicas | throttled seconds/periods, usage vs request/limit, latency, profiles, dependency metrics |
| `OOMKilled` | cgroup limit; application leak/burst | last termination reason/exit code, memory working set, limit, application profile |
| `Evicted` | node memory/disk/PID pressure; taint eviction | Pod reason/message, node conditions, eviction events, filesystem/inode data |
| HPA `<unknown>` | metrics API unavailable; missing requests; selector/target issue | HPA conditions/events, APIService, resource metrics, target template |
| HPA scales but Pods remain Pending | no compatible capacity; quota; topology/taint/PVC constraint | HPA desired/current, Pending events, autoscaler logs/status, node-group limits |
| Drain blocked | strict/impossible PDB; unhealthy replicas; unmanaged Pod; local data | eviction response, PDB status, controller ownership, readiness, drain output |
| Replicas share a domain | selector mismatch; missing labels; soft constraint; ineligible domains | rendered Pod spec, node labels, spread fields, scheduler events |

Do not infer throttling from CPU utilization alone or node-pressure eviction from
every exit 137. A container-level OOM kill, kubelet eviction, direct deletion,
preemption, and controller replacement have different owners and evidence.

A useful evidence packet contains exact context, object generation/resource
version, Pod UID, node, conditions, events, effective requests/limits, QoS and
priority, controller/HPA/PDB status, relevant metrics/logs, and a timestamped
recovery check. Remove secret values and tokens before sharing.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
