# Interview Questions

> **Module:** [11 — Helm](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
Use claim → mechanism → tradeoff → evidence. Prefer an incident or chart example
over a list of commands.

1. What is the difference between a chart, release, and revision?
2. Where does Helm stop and Kubernetes reconciliation begin?
3. What does Helm store in a release record, and why can values be sensitive?
4. How does values precedence work, and why can lists or `--set` be surprising?
5. Why treat `values.yaml` and its schema as a public API?
6. How would you design helper templates without hiding resource behavior?
7. What defects can lint, template, server dry run, and an ephemeral install each detect?
8. What does `--wait --wait-for-jobs --rollback-on-failure` guarantee, and what does it not guarantee?
9. Why is a Helm rollback a new revision? What cannot it reverse?
10. How would you deploy a breaking database schema change safely?
11. When would you choose an ordinary Job, a hook, or a separate migration pipeline?
12. Why does Helm not upgrade or delete CRDs automatically?
13. How do you handle a Kubernetes resource that existed before the release?
14. What is the difference between chart `version`, `appVersion`, image tag, and image digest?
15. How do dependency locks help, and what supply-chain risks remain?
16. How would you publish and promote a chart through an OCI registry?
17. How can a ConfigMap or Secret change trigger a Deployment rollout?
18. Why should a chart generally reference rather than generate long-lived secrets?
19. How does Helm behavior differ when Flux or Argo CD is the operator?
20. A release says `deployed`, but traffic fails. Describe your diagnostic path.
21. An upgrade is stuck in a pending state. What evidence do you collect before acting?
22. How do you test optional features and Kubernetes-version capabilities?
23. When is Helm the wrong abstraction compared with Kustomize or an operator?
24. What would make you trust a third-party chart in a production cluster?

> **Module:** [11 — Helm](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
