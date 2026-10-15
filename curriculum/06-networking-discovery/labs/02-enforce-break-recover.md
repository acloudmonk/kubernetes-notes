# Lab 2 — Enforce, Break, and Recover

> **Module:** [06 — Kubernetes Networking and Discovery](../README.md) · Previous: [Lab 1 — Trace CloudCart networking](01-trace-cloudcart-networking.md) · Next: [Cumulative exercise](../cumulative-exercise.md)

## Selector failure

Save the Service, seed a wrong selector, and observe DNS still resolving while
ready EndpointSlices become empty:

```powershell
kubectl patch service cloudcart-api -n cloudcart --type=merge -p '{"spec":{"selector":{"app.kubernetes.io/name":"wrong"}}}'
kubectl get service,endpointslice -n cloudcart -o wide
kubectl get httproute cloudcart -n cloudcart -o yaml
kubectl apply -f capstone/cloudcart/k8s/applications.yaml
```

Wait for two ready endpoints before continuing. Explain why HTTPRoute can remain
Accepted while requests fail due to an empty backend.

## Policy failure

Remove the API-to-PostgreSQL egress policy and observe readiness/endpoints:

```powershell
kubectl delete networkpolicy api-paths -n cloudcart
kubectl get pods,endpointslice -n cloudcart -w
```

After API endpoints disappear, restore policy and verify convergence:

```powershell
kubectl apply -f capstone/cloudcart/k8s/networking/network-policies.yaml
kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=180s
./curriculum/06-networking-discovery/scripts/Test-NetworkingLab.ps1
```

## Cleanup

```powershell
if ((kubectl config current-context) -ne 'kind-cloudcart-networking') { throw 'Unexpected context' }
if ((kind get clusters) -notcontains 'cloudcart-networking') { throw 'Cluster not found' }
kind delete cluster --name cloudcart-networking
kind get clusters
docker ps -a --filter 'name=cloudcart-networking' --format '{{.Names}} {{.Status}}'
```

Cluster deletion removes the generated credential, Envoy installation, CRDs,
policies, and disposable data. Confirm no matching containers remain.

> **Module:** [06 — Kubernetes Networking and Discovery](../README.md) · Previous: [Lab 1 — Trace CloudCart networking](01-trace-cloudcart-networking.md) · Next: [Cumulative exercise](../cumulative-exercise.md)
