# Quick Exercises

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Lifecycle, availability, and extensibility](04-cluster-lifecycle-extensibility.md) ·
> Next: [Lab 1 — Create and inspect a kind cluster](labs/01-create-and-inspect-cluster.md)

Do these before the labs. Write evidence, not one-word answers.

1. Draw the write path for a namespaced Deployment from kubeconfig selection
   through etcd. Mark authentication, authorization, mutation, validation, and
   the point at which a controller becomes involved.
2. Classify API server, CoreDNS, containerd, a CNI plugin, and an ingress
   controller as control plane, node component, interface implementation, or
   add-on. Some need more than one qualifier.
3. A Deployment has generation 8 and reports observed generation 6. State what
   is known, what is not known, and the next three pieces of evidence to collect.
4. Explain why a Pod may have an assigned node while remaining Pending.
5. Compare the consequences of losing one member in two-member and three-member
   etcd clusters.
6. Describe a deletion stuck on a finalizer without proposing that the finalizer
   be removed. Identify its owner and external cleanup evidence first.
7. For one managed Kubernetes offering you know, list five responsibilities
   that remain with the customer. Verify them against current provider docs.

## Success criteria

- Every transition names the component that owns it.
- Claims distinguish specification behavior from a common implementation.
- Failure answers include observable evidence and avoid deletion-first debugging.

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Lifecycle, availability, and extensibility](04-cluster-lifecycle-extensibility.md) ·
> Next: [Lab 1 — Create and inspect a kind cluster](labs/01-create-and-inspect-cluster.md)
