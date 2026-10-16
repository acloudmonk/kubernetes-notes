# CloudCart Helm Chart

This first-party learning chart packages CloudCart's API, outbox relay,
notification worker, migration Job, PostgreSQL, and RabbitMQ for a disposable
kind cluster. Follow [Module 11](../../../../curriculum/11-helm/README.md) for
the layered validation and release-lifecycle labs.

## Contract

- Helm 4.3.1 and Kubernetes 1.36.4 are the verified baseline.
- `values.schema.json` rejects unknown and invalid values.
- application configuration is stored in a release-owned ConfigMap;
- credentials must already exist in `credentials.existingSecret` and are never
  supplied as chart values;
- a revision-named, idempotent migration Job runs before workloads become useful;
- dedicated ServiceAccounts have API token automount disabled;
- the application image is loaded locally for kind and is never pulled;
- optional per-component topology-spread constraints support failure-domain labs;
- `helm test` checks the API readiness endpoint from inside the cluster.

## Validate and install

From the repository root, prefer the complete module scripts. The core chart
commands are:

```powershell
helm lint ./capstone/cloudcart/helm/cloudcart --strict
helm template cloudcart ./capstone/cloudcart/helm/cloudcart `
  --namespace cloudcart
helm upgrade --install cloudcart ./capstone/cloudcart/helm/cloudcart `
  --namespace cloudcart --wait --wait-for-jobs --rollback-on-failure
helm test cloudcart --namespace cloudcart --logs
```

The install requires the namespace, the external credential Secret, and the
local image prepared by `Deploy-HelmLab.ps1`. Do not paste credentials into
`--set`, values files, or committed manifests.

## Production boundary

The in-chart database and broker are single instances intended for learning.
They lack production high availability, backup automation, restore assurance,
TLS, and managed lifecycle. Production follows
[ADR 0005](../../../architecture/decisions/0005-managed-database-production.md),
[ADR 0006](../../../architecture/decisions/0006-external-secret-source.md), and
[ADR 0009](../../../architecture/decisions/0009-first-party-helm-release.md).
Promote immutable images and chart artifacts through a controlled registry,
and test data compatibility separately from Helm rollback.
