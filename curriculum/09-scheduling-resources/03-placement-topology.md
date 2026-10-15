# Placement, Isolation, and Topology

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Requests, limits, QoS, and pressure](02-resources-qos-pressure.md) · Next: [Disruption, priority, and autoscaling](04-disruption-autoscaling.md)

## Select the weakest sufficient rule

`nodeSelector` is a simple hard equality match. Node affinity adds expressions
and required/preferred terms. Inter-Pod affinity and anti-affinity relate a Pod
to labels on other Pods within a topology domain. Topology spread constraints
control skew across domains such as hostname or zone. Every hard rule reduces
the feasible set; combine rules only after checking their intersection.

Use required placement for genuine correctness or compliance boundaries, such
as architecture or dedicated regulated nodes. Use preferred rules for desired
cost, cache, or failure-domain behavior when degraded placement is acceptable.
CloudCart requires its application workers but uses topology spread to keep the
two API replicas on different hostnames.

`requiredDuringSchedulingIgnoredDuringExecution` is evaluated at scheduling
time; later label drift does not normally evict the Pod. Labels used for
isolation must be controlled. Prefer protected label prefixes enforced by the
NodeRestriction admission plugin rather than trusting a node to self-assert a
sensitive identity.

## Taints are repulsion, tolerations are permission

A taint effect (`NoSchedule`, `PreferNoSchedule`, or `NoExecute`) repels Pods.
A matching toleration permits consideration; it does not select that node.
Dedicated pools commonly combine a taint with required node affinity. A
`NoExecute` taint can evict existing Pods, subject to matching tolerations and
optional `tolerationSeconds`.

## Spread and failure domains

Topology spread uses a label selector, topology key, maximum skew, and
`DoNotSchedule` or `ScheduleAnyway`. Eligible domains are affected by node
affinity and taints. Missing or inconsistent topology labels can make domains
invisible or placement impossible. Decide what happens when there are fewer
domains than replicas and whether strict availability or prompt scheduling wins.

Pod anti-affinity expresses relationships but can be expensive and awkward at
scale. Spread constraints usually state distribution intent more directly.
Neither creates failure-domain independence if storage, networking, power, or
the underlying virtualization layer is shared.

## Storage participates in scheduling

With `WaitForFirstConsumer`, volume binding waits for Pod placement so the
provisioner can honor zone/node topology. A bound local or zonal volume can then
constrain rescheduling. Diagnose Pod and PVC events together; adding generic
compute capacity in the wrong zone may not help a stateful Pod.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Requests, limits, QoS, and pressure](02-resources-qos-pressure.md) · Next: [Disruption, priority, and autoscaling](04-disruption-autoscaling.md)
