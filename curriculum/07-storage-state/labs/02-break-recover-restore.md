# Lab 2 — Break, Recover, Back Up, and Restore

> **Module:** [07 — Kubernetes Storage and State](../README.md) · Previous: [Lab 1 — Persist and trace CloudCart state](01-persist-trace-cloudcart.md) · Next: [Independent challenge](../independent-challenge.md)

## Diagnose a Pending claim

Create a claim that requests a nonexistent class:

```powershell
kubectl apply -f curriculum/07-storage-state/lab/pending-pvc.yaml
kubectl get pvc intentionally-pending -n cloudcart
kubectl describe pvc intentionally-pending -n cloudcart
kubectl get storageclass
```

Prove the failure is class selection/provisioning rather than Pod startup or a
mount. Repair by deleting only the intentionally broken claim; do not change a
production claim's immutable class in place.

```powershell
kubectl delete pvc intentionally-pending -n cloudcart
```

## Verify StatefulSet claim retention

Record the claim UID and PV, delete only the controller, and observe that the
configured `whenDeleted: Retain` policy leaves the PVC intact:

```powershell
$ClaimUid = kubectl get pvc data-postgres-0 -n cloudcart -o jsonpath='{.metadata.uid}'
$Volume = kubectl get pvc data-postgres-0 -n cloudcart -o jsonpath='{.spec.volumeName}'
kubectl delete statefulset postgres -n cloudcart --wait=true
kubectl get pvc data-postgres-0 -n cloudcart -o wide
kubectl apply -f capstone/cloudcart/k8s/storage/postgres-statefulset.yaml
kubectl rollout status statefulset/postgres -n cloudcart --timeout=180s
kubectl get pvc data-postgres-0 -n cloudcart -o jsonpath='{.metadata.uid}{"`n"}{.spec.volumeName}{"`n"}'
kubectl exec -n cloudcart postgres-0 -- psql -U cloudcart -d cloudcart -tAc 'SELECT count(*) FROM ordering.orders;'
```

Confirm the UID and PV equal `$ClaimUid` and `$Volume` and that orders remain.
Explain why StatefulSet PVC retention precedes, but does not replace, the PV's
reclaim policy when a PVC is eventually deleted.

## Test logical backup and isolated restore

```powershell
./curriculum/07-storage-state/scripts/Test-BackupRestore.ps1
```

The script creates a custom-format archive under ignored `tmp/module07`, restores
it to `cloudcart_restore`, compares order counts, drops the restored database,
and removes local/in-Pod artifacts. It does not print credentials or alter the
active database. Explain why a separate target and application-aware assertions
are safer than restoring directly over the source.

## Reason about larger failures

Inspect PV node affinity and answer:

- Can this local volume follow the Pod to the other kind node?
- What survives Pod deletion, StatefulSet deletion, PVC deletion, node-container
  deletion, and whole-cluster deletion?
- Which protections would change with network/cloud block storage, Retain,
  snapshots, replication, and off-cluster backups?

Do not delete a kind node to test durability: the local-path backend is explicitly
disposable and that action adds no new safe recovery evidence.

## Cleanup

```powershell
if ((kubectl config current-context) -ne 'kind-cloudcart-storage') { throw 'Unexpected context' }
if ((kind get clusters) -notcontains 'cloudcart-storage') { throw 'Cluster not found' }
kind delete cluster --name cloudcart-storage
kind get clusters
docker ps -a --filter 'name=cloudcart-storage' --format '{{.Names}} {{.Status}}'
```

Confirm the named cluster and matching containers are gone. Cluster deletion
also destroys the node-local PV; retained Kubernetes objects cannot outlive the
cluster that stored them.

> **Module:** [07 — Kubernetes Storage and State](../README.md) · Previous: [Lab 1 — Persist and trace CloudCart state](01-persist-trace-cloudcart.md) · Next: [Independent challenge](../independent-challenge.md)
