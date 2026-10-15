# Lab 1 — Trace CloudCart Networking

> **Module:** [06 — Kubernetes Networking and Discovery](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Enforce, break, and recover](02-enforce-break-recover.md)

## Deploy

Build `cloudcart-app:0.1.0` if absent, then create the pinned disposable cluster:

```powershell
$NodeImage = 'kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed'
docker build --tag cloudcart-app:0.1.0 capstone/cloudcart
kind create cluster --config curriculum/06-networking-discovery/lab/kind-config.yaml --image $NodeImage --wait 120s
./curriculum/06-networking-discovery/scripts/Deploy-NetworkingLab.ps1
./curriculum/06-networking-discovery/scripts/Test-NetworkingLab.ps1
```

The deployment downloads the pinned official Envoy Gateway 1.8.5 installer.
Review external YAML before reuse in a sensitive cluster.

## Trace evidence

```powershell
kubectl get pods -A -o wide
kubectl get service,endpointslice -n cloudcart -o wide
kubectl get gatewayclass,gateway,httproute -A
kubectl describe gateway cloudcart -n cloudcart
kubectl describe httproute cloudcart -n cloudcart
kubectl get networkpolicy -n cloudcart
kubectl exec -n cloudcart deployment/cloudcart-api -- python -c "import socket; print(socket.gethostbyname_ex('postgres.cloudcart.svc.cluster.local'))"
kubectl exec -n cloudcart deployment/cloudcart-api -- cat /etc/resolv.conf
```

Identify Pod, Service, and node CIDRs; API Service virtual IP; ready endpoints;
DNS search path; Envoy proxy Deployment/Service; route conditions; and every
allowed CloudCart edge. In this kind baseline, explain why the listener and
proxy route traffic while the Gateway reports `AddressNotAssigned` without a
LoadBalancer implementation. Keep the cluster for Lab 2.

> **Module:** [06 — Kubernetes Networking and Discovery](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Enforce, break, and recover](02-enforce-break-recover.md)
