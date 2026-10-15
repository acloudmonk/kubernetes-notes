# Independent Challenge

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Cumulative exercise](cumulative-exercise.md) · Next: [Troubleshooting](troubleshooting.md)

Design placement and capacity policy for a three-component service across three
failure domains. Include one latency-sensitive API, one interruptible worker,
and one stateful component with zonal storage. Define measured requests, any
limits, QoS consequences, required/preferred placement, taints/tolerations,
spread behavior during domain loss, PriorityClasses, PDBs, HPA signals and
behavior, node-autoscaling assumptions, quotas, and maintenance procedure.

Then implement it in a disposable cluster and inject: insufficient capacity,
a missing topology label, CPU saturation, memory-limit breach, metrics outage,
and a blocked drain. For each, submit prediction, API/events/metrics evidence,
smallest repair, recovery proof, and cleanup. Do not weaken every constraint,
delete state, or assign system-critical priority as a shortcut.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Cumulative exercise](cumulative-exercise.md) · Next: [Troubleshooting](troubleshooting.md)
