# Lab 2 — Diagnose and Rotate Safely

> **Module:** [08 — Kubernetes Configuration and Secrets](../README.md) · Previous: [Lab 1 — Observe configuration lifecycle](01-observe-configuration.md) · Next: [Independent challenge](../independent-challenge.md)

## Diagnose a required Secret failure

```powershell
kubectl apply -f curriculum/08-configuration-secrets/lab/missing-secret-pod.yaml
kubectl get pod missing-secret-consumer -n cloudcart
kubectl describe pod missing-secret-consumer -n cloudcart
kubectl get events -n cloudcart --field-selector involvedObject.name=missing-secret-consumer
```

The Pod should show `CreateContainerConfigError` and a missing Secret event; it
should not reach image process startup. Do not create a fake value to silence a
required dependency. Remove only the intentional failure:

```powershell
kubectl delete pod missing-secret-consumer -n cloudcart --wait=true
```

## Rotate the generated database credential

```powershell
./curriculum/08-configuration-secrets/scripts/Rotate-DatabaseCredential.ps1
```

The script keeps old/new generated values only in process variables, changes
the PostgreSQL role through stdin, replaces the Secret through stdin, rolls API,
relay, and worker, and proves a new order persists. It reports metadata and
outcomes, never credential values. On failure it attempts to restore the old
lab credential and consumer rollouts.

Explain why this single-password sequence has a bounded risk window and how a
second credential/role would permit overlap, gradual rollout, verification, and
old-credential revocation in production.

## Cleanup

```powershell
if ((kubectl config current-context) -ne 'kind-cloudcart-configuration') { throw 'Unexpected context' }
if ((kind get clusters) -notcontains 'cloudcart-configuration') { throw 'Cluster not found' }
kind delete cluster --name cloudcart-configuration
kind get clusters
docker ps -a --filter 'name=cloudcart-configuration' --format '{{.Names}} {{.Status}}'
```

Confirm the named cluster and matching containers are gone. This removes the
generated credentials and disposable data without exporting either.

> **Module:** [08 — Kubernetes Configuration and Secrets](../README.md) · Previous: [Lab 1 — Observe configuration lifecycle](01-observe-configuration.md) · Next: [Independent challenge](../independent-challenge.md)
