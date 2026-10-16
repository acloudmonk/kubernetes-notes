# Knowledge Check

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

Answer every question before reading the answer section.

1. Does rebuilding the same commit guarantee the same artifact?
2. What identity should connect tests, SBOM, signature, provenance, and deployment?
3. Does an SBOM prove a component is vulnerability-free?
4. Why is a valid signature insufficient authorization?
5. What does provenance add beyond a signature?
6. Does Git history prove cluster state?
7. Which Flux controller fetches a GitRepository?
8. What does a Flux Kustomization inventory support?
9. Should a CLI user and Flux manage the same Helm release?
10. What happens to an ordinary manual edit of a Flux-managed field?
11. Does Git revert undo database mutations?
12. Why must a vulnerability exception expire?

---

## Answers

1. No; dependencies, builder, time, network inputs, and nondeterminism can change bytes.
2. The immutable artifact digest, bound to the source revision and trusted builder.
3. No; it is inventory, and both completeness and advisory data have limits.
4. The signer may be genuine but not an approved issuer, subject, workflow, or source.
5. Trusted claims about how and from which materials the artifact was built.
6. No; controller status and runtime evidence are required.
7. Source Controller.
8. Drift ownership and pruning of objects previously applied from desired state.
9. No; competing authoritative writers create drift and unsafe lifecycle actions.
10. Reconciliation normally restores the declared value.
11. No; data recovery or a compatible forward change is separate.
12. Risk and fixes change; permanent waivers silently become policy bypasses.

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
