# 09 — Kubernetes Scheduling and Resources

**Status:** Verified<br>
**Estimated time:** 24–30 hours<br>
**Prerequisites:** [08 — Kubernetes Configuration and Secrets](../08-configuration-secrets/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Configuration and secrets](../08-configuration-secrets/README.md) · Next: [Security and policy](../10-security-policy/README.md)

## Why this matters

A running Pod is the result of capacity accounting, placement policy, node
conditions, and several independent control loops. Incorrect requests waste
capacity or create contention; overly strict placement leaves Pods Pending;
limits can throttle or kill healthy code; and autoscaling can amplify a bad
resource model. This module connects those mechanisms to observable evidence.

## Learning objectives

You can trace scheduling from queue to binding, calculate effective Pod
requests, distinguish QoS from priority, design hard and soft placement rules,
reason about eviction and disruption, configure HPA safely, and diagnose
Pending, throttled, OOM-killed, and capacity-constrained workloads.

## Contents

1. [Scheduler pipeline and resource accounting](01-scheduler-pipeline.md)
2. [Requests, limits, QoS, and pressure](02-resources-qos-pressure.md)
3. [Placement, isolation, and topology](03-placement-topology.md)
4. [Disruption, priority, and autoscaling](04-disruption-autoscaling.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Place and protect CloudCart](labs/01-place-protect.md)
7. [Lab 2 — Diagnose scheduling and resource failures](labs/02-diagnose-resources.md)
8. [Cumulative exercise — Operate state under constrained capacity](cumulative-exercise.md)
9. [Independent challenge](independent-challenge.md)
10. [Troubleshooting](troubleshooting.md)
11. [Interview questions](interview-questions.md)
12. [Knowledge check](quiz.md)
13. [References and videos](references.md)

## Tested baseline

The lab targets kind 0.33.0, Kubernetes 1.36.4, and Metrics Server 0.9.0. It
uses one control-plane and two labeled worker nodes. The deployment composes the
verified Module 08 baseline, applies versioned CloudCart scheduling policies,
and uses disposable fixtures for Pending, QoS, and OOMKilled evidence. The full
deployment and test scripts passed twice on a fresh cluster, including
server-side validation and scoped cleanup.

## Completion

- [ ] **Explain:** trace queue, filter, score, reserve, permit, bind, and kubelet admission.
- [ ] **Build:** define defensible requests, placement, PDB, priority, and HPA behavior.
- [ ] **Diagnose:** distinguish unschedulable, throttled, OOM-killed, evicted, and unavailable.
- [ ] **Operate:** preserve the CloudCart event path while applying capacity constraints.
- [ ] Complete the independent and cumulative exercises.

## Continue

Continue to [10 — Kubernetes Security and Policy](../10-security-policy/README.md),
or return to the [curriculum index](../README.md).
