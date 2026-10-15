# Lab 3 — Observe Control-Plane and Node Failure

> **Module:** [04 — Kubernetes Architecture](../README.md) · Previous:
> [Lab 2 — Trace reconciliation](02-trace-reconciliation.md) · Next:
> [Independent challenge](../independent-challenge.md)

## Outcome and safety

Stop only the named kind node containers, capture symptoms, restore them, and
distinguish API unavailability from stale node heartbeats. This intentionally
interrupts the temporary lab cluster. It does not delete repository or host data.

Confirm the targets before every stop:

```powershell
kind get clusters
docker ps --filter 'name=architecture-lab' --format '{{.Names}} {{.Status}}'
```

Proceed only when the exact cluster and the two expected node containers are shown.

## Failure 1: control-plane container stopped

```powershell
docker stop architecture-lab-control-plane
kubectl get nodes --request-timeout=5s
```

The API request should fail, while the worker container and its existing
workload process remain present:

```powershell
docker ps --filter 'name=architecture-lab-worker' --format '{{.Names}} {{.Status}}'
docker exec architecture-lab-worker crictl ps --name pause
```

Recover and verify:

```powershell
docker start architecture-lab-control-plane
$apiReady = $false
foreach ($attempt in 1..24) {
  kubectl get --raw=/readyz --request-timeout=5s
  if ($LASTEXITCODE -eq 0) { $apiReady = $true; break }
  Start-Sleep -Seconds 5
}
if (-not $apiReady) { throw 'API did not recover within 120 seconds' }
./curriculum/04-kubernetes-architecture/scripts/Test-ArchitectureLab.ps1
```

This single-control-plane lab has no API redundancy. Existing containers can
continue, but controllers, new scheduling, and API operations were unavailable.

## Failure 2: worker container stopped

```powershell
docker stop architecture-lab-worker
```

Poll rather than assuming an immediate transition:

```powershell
1..12 | ForEach-Object {
  kubectl get node architecture-lab-worker
  Start-Sleep -Seconds 5
}
kubectl get lease -n kube-node-lease architecture-lab-worker -o yaml
kubectl get pods -n architecture-lab -o wide
```

The API remains reachable. The worker eventually becomes Unknown/NotReady
because heartbeats and its Lease stop renewing. The transition can occur just
after this one-minute observation because node monitoring uses grace periods;
compare heartbeat and Lease timestamps instead of treating a stale Ready value
as live proof. Pods may remain associated with that node during this short
observation; rescheduling is governed by separate eviction and toleration timing.

Recover and verify:

```powershell
docker start architecture-lab-worker
kubectl wait --for=condition=Ready node/architecture-lab-worker --timeout=120s
kubectl rollout status deployment/reconciliation-trace -n architecture-lab --timeout=120s
./curriculum/04-kubernetes-architecture/scripts/Test-ArchitectureLab.ps1
```

## Precise cleanup

Delete only after verifying the exact name and context:

```powershell
if ((kubectl config current-context) -ne 'kind-architecture-lab') {
  throw 'Refusing cleanup: unexpected context'
}
if ((kind get clusters) -notcontains 'architecture-lab') {
  throw 'Refusing cleanup: architecture-lab not found'
}
kubectl delete -f curriculum/04-kubernetes-architecture/lab/trace-workload.yaml --wait=true
kind delete cluster --name architecture-lab
kind get clusters
docker ps -a --filter 'name=architecture-lab' --format '{{.Names}} {{.Status}}'
```

Success means the named cluster and node containers are absent. Do not delete
other kind clusters or kubeconfig files.

> **Module:** [04 — Kubernetes Architecture](../README.md) · Previous:
> [Lab 2 — Trace reconciliation](02-trace-reconciliation.md) · Next:
> [Independent challenge](../independent-challenge.md)
