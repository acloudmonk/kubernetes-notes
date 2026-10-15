# Lab 1 — Create and Inspect a kind Cluster

> **Module:** [04 — Kubernetes Architecture](../README.md) · Previous:
> [Quick exercises](../quick-exercises.md) · Next:
> [Lab 2 — Trace reconciliation](02-trace-reconciliation.md)

## Outcome and safety

Create the named local cluster `architecture-lab`, prove the client/server
versions and component placement, then retain it for Labs 2–3. kind nodes are
Docker containers; this is not a production topology.

The commands below create containers and a kubeconfig context. Cleanup deletes
only the exact cluster name after you verify it. Do not store or commit the
generated kubeconfig.

## Prerequisites

- Docker Desktop is using Linux containers and `docker info` succeeds.
- `kubectl version --client` succeeds.
- kind 0.33.0 is installed. On Windows, `winget install Kubernetes.kind`; for
  other platforms follow the official kind installation instructions.

Use PowerShell from the repository root:

```powershell
docker info --format '{{.OSType}}/{{.Architecture}}'
kind version
kubectl version --client
```

## Create the pinned cluster

```powershell
$NodeImage = 'kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed'
kind create cluster --config curriculum/04-kubernetes-architecture/lab/kind-config.yaml --image $NodeImage --wait 120s
```

The digest prevents a tag from resolving to unexpected content. The committed
configuration declares one control-plane and one labeled worker node.

## Verify the API and nodes

```powershell
kubectl config current-context
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -n kube-system -o wide
./curriculum/04-kubernetes-architecture/scripts/Test-ArchitectureLab.ps1
```

Expected evidence:

- context `kind-architecture-lab`;
- server version 1.36.4 and two Ready nodes;
- control-plane components on `architecture-lab-control-plane`;
- CoreDNS and kube-proxy visible as add-on/node workloads;
- the verification script prints `result=PASS`.

## Inspect API discovery and node internals

```powershell
kubectl get --raw /version
kubectl api-resources
kubectl explain deployment.spec
docker exec architecture-lab-control-plane ls /etc/kubernetes/manifests
docker exec architecture-lab-worker crictl ps
```

Connect the evidence to the model:

- static Pod manifests bootstrap control-plane components in this kind node;
- `crictl` talks to the node's CRI runtime rather than Docker Engine;
- API discovery reports resource name, kind, scope, and served versions.

Do not clean up yet. Continue directly to Lab 2.

> **Module:** [04 — Kubernetes Architecture](../README.md) · Previous:
> [Quick exercises](../quick-exercises.md) · Next:
> [Lab 2 — Trace reconciliation](02-trace-reconciliation.md)
