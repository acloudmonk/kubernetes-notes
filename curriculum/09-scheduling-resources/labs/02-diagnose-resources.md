# Lab 2 — Diagnose Scheduling and Resource Failures

> **Module:** [09 — Kubernetes Scheduling and Resources](../README.md) · Previous: [Lab 1 — Place and protect CloudCart](01-place-protect.md) · Next: [Cumulative exercise](../cumulative-exercise.md)

The test script applies three controlled fixtures. Before running it, predict
each result from the manifest rather than memorizing a command.

1. `qos-pods.yaml` creates Guaranteed, Burstable, and BestEffort Pods. Derive
   each class from every container's CPU and memory fields, then verify
   `.status.qosClass`.
2. `unschedulable-pod.yaml` requests 100 CPU. Inspect `PodScheduled=False`,
   `spec.nodeName`, scheduler events, node allocatable, and allocated requests.
   Prove the first failed boundary is capacity, not image pull or startup.
3. `oom-pod.yaml` allocates beyond a 32 MiB cgroup limit. Distinguish its
   terminated `OOMKilled` state from kubelet node-pressure `Evicted` and from
   an application exit.

Run the complete test:

```powershell
./curriculum/09-scheduling-resources/scripts/Test-SchedulingLab.ps1
```

It also proves metrics/HPA conditions, PDB health, worker placement, API spread,
and the order → outbox → broker → worker event path. Fixture Pods are deleted in
a `finally` block; the CloudCart baseline remains for investigation. If a check
fails, capture `kubectl get pod -o yaml`, ordered events, controller status, node
allocatable/requests, and relevant logs before repairing only the failed layer.

> **Module:** [09 — Kubernetes Scheduling and Resources](../README.md) · Previous: [Lab 1 — Place and protect CloudCart](01-place-protect.md) · Next: [Cumulative exercise](../cumulative-exercise.md)
