# Quick Exercises

> **Module:** [11 — Helm](README.md) · Previous: [Testing, distribution, security, and GitOps](04-testing-distribution-gitops.md) · Next: [Lab 1 — Author and validate the chart](labs/01-author-validate-chart.md)
Complete these before the guided labs. Record commands, predictions, and the
evidence that confirmed or disproved each prediction.

1. Draw chart → values merge → template render → API apply → controller
   reconciliation → release-state storage. Mark which steps need a cluster.
2. Render CloudCart twice with different release names. Explain every changed
   name, label, selector, and note.
3. Override `config.relayIntervalSeconds` with `--set` and `--set-string`.
   Predict types, then use a deliberately invalid value and read the schema error.
4. Add an unknown root value. Explain why rejecting it is safer than ignoring a typo.
5. Trace `credentials.existingSecret` from values to every consumer. Prove no
   password value exists in the chart, package, or rendered manifest.
6. Compare `helm template`, client dry run, server dry run, install with wait,
   and `helm test`. List one defect each layer can find that the earlier one cannot.
7. Inspect the checksum annotation. Explain why a ConfigMap change causes a
   rollout while an unchanged Pod template does not.
8. Predict the release history after install, successful upgrade, failed
   upgrade, and rollback. Verify your model in Lab 2.
9. Decide whether database migration should be a normal Job, hook, or separate
   pipeline for a zero-downtime production rollout. State assumptions.
10. Design a chart/version/application/image version matrix and identify which
    identifier is immutable.

> **Module:** [11 — Helm](README.md) · Previous: [Testing, distribution, security, and GitOps](04-testing-distribution-gitops.md) · Next: [Lab 1 — Author and validate the chart](labs/01-author-validate-chart.md)
