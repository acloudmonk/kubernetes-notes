# Lab 2 — Fail, Update, and Recover

> **Module:** [05 — Kubernetes Workloads](../README.md) · Previous: [Lab 1 — Deploy CloudCart](01-deploy-cloudcart.md) · Next: [Independent challenge](../independent-challenge.md)

## Readiness failure

Scale PostgreSQL to zero and observe rather than delete API Pods:

```powershell
kubectl scale deployment/postgres -n cloudcart --replicas=0
kubectl get pods,endpointslice -n cloudcart -w
```

Stop the watch after API endpoints become unready. API liveness should continue,
readiness should fail, containers should not restart, and the Service should
have no ready API endpoints. Restore the dependency; because its `emptyDir`
data was deleted, rerun the idempotent migration:

```powershell
kubectl scale deployment/postgres -n cloudcart --replicas=1
kubectl rollout status deployment/postgres -n cloudcart --timeout=180s
kubectl delete job cloudcart-migrate -n cloudcart --ignore-not-found --wait=true
kubectl apply -f capstone/cloudcart/k8s/migration-job.yaml
kubectl wait --for=condition=complete job/cloudcart-migrate -n cloudcart --timeout=180s
kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=180s
```

## Bad rollout and rollback

```powershell
kubectl set image deployment/cloudcart-api api=cloudcart-app:does-not-exist -n cloudcart
kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=30s
kubectl get replicasets,pods -n cloudcart
kubectl describe pod -n cloudcart -l app.kubernetes.io/name=cloudcart-api
kubectl rollout undo deployment/cloudcart-api -n cloudcart
kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=180s
./curriculum/05-kubernetes-workloads/scripts/Test-CloudCartWorkloads.ps1
```

Explain why `maxUnavailable: 0` preserved old ready replicas, why the rollout
reported failure rather than self-rollback, and which Events proved image pull
failure.

## Precise cleanup

```powershell
if ((kubectl config current-context) -ne 'kind-cloudcart-workloads') { throw 'Unexpected context' }
if ((kind get clusters) -notcontains 'cloudcart-workloads') { throw 'Cluster not found' }
kubectl delete namespace cloudcart --wait=true
kind delete cluster --name cloudcart-workloads
kind get clusters
docker ps -a --filter 'name=cloudcart-workloads' --format '{{.Names}} {{.Status}}'
```

The named cluster and matching containers must be absent. The local application
image may remain for later labs and contains no credential.

> **Module:** [05 — Kubernetes Workloads](../README.md) · Previous: [Lab 1 — Deploy CloudCart](01-deploy-cloudcart.md) · Next: [Independent challenge](../independent-challenge.md)
