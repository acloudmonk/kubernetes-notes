# Lab 2 — Trace Reconciliation

> **Module:** [04 — Kubernetes Architecture](../README.md) · Previous:
> [Lab 1 — Create and inspect a kind cluster](01-create-and-inspect-cluster.md) ·
> Next: [Lab 3 — Observe control-plane and node failure](03-control-plane-and-node-failure.md)

## Outcome

Apply a Deployment with server-side field ownership and prove the Deployment →
ReplicaSet → Pod ownership chain, scheduling decision, and node-side runtime
state. Then change desired replicas and observe convergence.

## Confirm the exact context

```powershell
if ((kubectl config current-context) -ne 'kind-architecture-lab') {
  throw 'Expected kind-architecture-lab context'
}
```

## Write desired state

```powershell
kubectl apply --server-side --field-manager=module-04-lab -f curriculum/04-kubernetes-architecture/lab/trace-workload.yaml
kubectl rollout status deployment/reconciliation-trace -n architecture-lab --timeout=120s
kubectl get deployment,replicaset,pod -n architecture-lab -o wide
```

Inspect API identity and field ownership:

```powershell
kubectl get deployment reconciliation-trace -n architecture-lab -o yaml
kubectl get pods -n architecture-lab -o custom-columns='NAME:.metadata.name,OWNER_KIND:.metadata.ownerReferences[0].kind,OWNER:.metadata.ownerReferences[0].name,NODE:.spec.nodeName,READY:.status.containerStatuses[0].ready'
kubectl get events -n architecture-lab --sort-by=.metadata.creationTimestamp
```

Find the ReplicaSet owner reference on each Pod and the Deployment owner
reference on the ReplicaSet. Confirm Pods use the labeled worker. In the
Deployment YAML locate `generation`, `observedGeneration`, conditions, and the
`module-04-lab` entry in `managedFields`.

## Observe node-side execution

```powershell
docker exec architecture-lab-worker crictl pods --name reconciliation-trace
docker exec architecture-lab-worker crictl ps --name pause
```

kind uses containerd inside each node. Docker sees node containers; `crictl`
inside the worker sees Kubernetes Pod sandboxes and containers.

## Change desired state

```powershell
kubectl scale deployment/reconciliation-trace -n architecture-lab --replicas=3
kubectl rollout status deployment/reconciliation-trace -n architecture-lab --timeout=120s
kubectl get deployment,replicaset,pod -n architecture-lab -o wide
```

Explain which actor updated the Deployment, which controller created a Pod,
which component selected its node, and which component started its container.
Then restore the committed desired state:

```powershell
kubectl apply --server-side --field-manager=module-04-lab --force-conflicts -f curriculum/04-kubernetes-architecture/lab/trace-workload.yaml
kubectl rollout status deployment/reconciliation-trace -n architecture-lab --timeout=120s
```

`--force-conflicts` is explicit because `kubectl scale` may own the replicas
field. Do not use it casually in shared environments; understand whose field
ownership is being replaced.

Keep the workload and cluster for Lab 3.

> **Module:** [04 — Kubernetes Architecture](../README.md) · Previous:
> [Lab 1 — Create and inspect a kind cluster](01-create-and-inspect-cluster.md) ·
> Next: [Lab 3 — Observe control-plane and node failure](03-control-plane-and-node-failure.md)
