# Lab 2 — Upgrade, Fail, and Roll Back

> **Module:** [11 — Helm](../README.md) · Previous: [Lab 1 — Author and validate the chart](01-author-validate-chart.md) · Next: [Independent challenge](../independent-challenge.md)
## Goal

Prove a safe configuration rollout, collect evidence from an intentionally
failed image upgrade, restore a prior revision, revalidate application behavior,
and package the exact chart.

## Procedure

Run the automated lifecycle exercise against the Lab 1 release:

```powershell
./curriculum/11-helm/scripts/Test-HelmLifecycle.ps1
```

The script:

1. records the deployed revision and release ownership;
2. confirms the external Secret is not owned by Helm;
3. changes the relay interval and proves the ConfigMap checksum rolls the Pod;
4. attempts an upgrade with a nonexistent image and retains the failure revision;
5. reads history and rolls back to the last successful revision;
6. runs the chart test and submits an order through the full event path;
7. packages the chart in ignored `tmp/module11` and checks archive metadata.

Inspect the evidence yourself:

```powershell
helm history cloudcart --namespace cloudcart
helm status cloudcart --namespace cloudcart --show-resources
kubectl get events --namespace cloudcart --sort-by=.metadata.creationTimestamp
kubectl describe deployment cloudcart-api --namespace cloudcart
```

Answer these questions:

- Why does rollback add a revision rather than remove the failed one?
- Which external side effects would not be restored by this rollback?
- What prevented the external Secret from becoming release-owned?
- Why did the checksum change matter to Deployment reconciliation?
- What would differ if a GitOps controller owned the release?

## Cleanup

Delete only the disposable lab cluster after preserving non-sensitive notes:

```powershell
kind delete cluster --name cloudcart-helm
Remove-Item -Recurse -Force tmp/module11
```

Do not reuse the cleanup command with another cluster name or directory.

> **Module:** [11 — Helm](../README.md) · Previous: [Lab 1 — Author and validate the chart](01-author-validate-chart.md) · Next: [Independent challenge](../independent-challenge.md)
