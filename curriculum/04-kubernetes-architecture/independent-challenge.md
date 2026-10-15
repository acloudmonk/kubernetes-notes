# Independent Challenge

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Lab 3 — Observe control-plane and node failure](labs/03-control-plane-and-node-failure.md) ·
> Next: [Troubleshooting](troubleshooting.md)

## Scenario

A team reports: “The application is broken; Kubernetes did not deploy it.” You
receive a namespace containing a Deployment whose desired replicas are not all
available. Without using a command-by-command solution, build a reproducible
investigation that locates the first failed control boundary.

## Constraints

- Use a disposable local cluster with at least one worker distinct from the control plane.
- Create one failure in placement or node-side execution; do not reveal it in the incident prompt.
- Capture evidence before changing or deleting resources.
- Do not use floating image tags, real credentials, privileged containers, or host mounts.
- Recovery must be a desired-state correction, not manual container creation.
- Precisely remove only challenge resources and its named cluster.

## Deliverables

1. A diagram from API request through controller, scheduler, kubelet, CRI, and status.
2. A short evidence log containing context, server version, desired generation,
   observed generation, owner chain, conditions, Events, placement, and node state.
3. A diagnosis naming the first failed boundary and why alternatives were rejected.
4. A correction, verification, prevention measure, and exact cleanup evidence.

## Acceptance criteria

- Another learner can reproduce the symptom from committed, non-sensitive inputs.
- Every conclusion cites observable cluster evidence.
- The recovered workload reaches its declared replica count.
- The explanation distinguishes temporary convergence from persistent failure.
- No generated kubeconfig, token, key, diagnostic archive, or cluster container remains.

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Lab 3 — Observe control-plane and node failure](labs/03-control-plane-and-node-failure.md) ·
> Next: [Troubleshooting](troubleshooting.md)
