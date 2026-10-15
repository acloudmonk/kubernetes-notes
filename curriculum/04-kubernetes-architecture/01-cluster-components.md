# Cluster Components and Responsibility Boundaries

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Module overview](README.md) · Next:
> [API requests and the object model](02-api-request-and-object-model.md)

## The cluster is a control system

Users submit desired state to the Kubernetes API. Independent control loops
observe that durable state and the real world, then act until observed state
approaches desired state. There is no single command coordinator that performs
every step. Temporary disagreement is normal; persistent disagreement is the
condition to diagnose.

The API is the control-plane boundary. Components should communicate through
it rather than modifying another component's internal state. `etcd` is the
consistent backing store used by the API server; clients and controllers do
not use etcd directly.

## Control-plane components

| Component | Owns | Does not own |
|---|---|---|
| `kube-apiserver` | API endpoints, validation, authentication integration, authorization, admission, persistence interface, watch streams | Workload execution or business-level reconciliation |
| `etcd` | Consistent storage for API data | Kubernetes policy, scheduling, or direct client access |
| `kube-controller-manager` | Built-in control loops such as Deployment-related controllers, node lifecycle, endpoints, and garbage collection | Selecting a node for an unscheduled Pod |
| `kube-scheduler` | Filtering and scoring feasible nodes, then recording a binding | Starting containers on that node |
| cloud controller manager | Cloud-specific node, route, load-balancer, or volume integration when configured | Core Kubernetes behavior or every provider integration |

Production control planes commonly run multiple API-server instances behind a
load balancer and elect one active leader for controller-manager and scheduler
work. etcd availability and quorum are separate concerns. A two-member etcd
cluster tolerates no member loss; odd member counts such as three or five are
used to retain quorum after failures.

## Node components and extension boundaries

- **kubelet** watches assigned Pods, asks the runtime to create sandboxes and
  containers, mounts declared volumes, runs probes, and reports status.
- **container runtime** implements the Container Runtime Interface (CRI).
  `containerd` with its CRI plugin is common; Kubernetes does not require
  Docker Engine on cluster nodes.
- **kube-proxy** commonly programs node networking rules for Services. Some
  networking implementations replace this data-plane role.
- **CNI plugin** supplies Pod network attachment and addressability. Network
  policy enforcement depends on the selected implementation.
- **CSI driver** supplies storage operations through the Container Storage
  Interface. Kubernetes objects describe intent; the driver and storage system
  perform provider-specific work.

CRI, CNI, and CSI are contracts, not single products. Ask which implementation
is installed before assuming commands, performance, or failure behavior.

## Add-ons are workloads

DNS, metrics collection, ingress or Gateway controllers, dashboard software,
and observability agents usually run as Kubernetes workloads. They are
important but not all are core control-plane components. Their outage may
break application behavior while the API itself remains healthy.

## Responsibility changes by environment

| Environment | Learner or platform team typically owns |
|---|---|
| kind | Docker host, node containers, Kubernetes configuration, all workloads |
| Self-managed | Control plane, etcd backup, nodes, networking, storage integrations, upgrades, workloads |
| Managed Kubernetes | Workloads and many integrations; provider operates some control-plane concerns, but customer still owns configuration, access, versions, capacity, and recovery obligations defined by the service |

“Managed” does not mean “operated end to end.” Confirm the provider's shared
responsibility model and backup/restore guarantees.

## Review prompts

- Why is a running API server insufficient proof that application networking works?
- Which boundary would you inspect when a Pod is scheduled but no sandbox appears?
- Why should a controller use the API instead of reading etcd directly?

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Module overview](README.md) · Next:
> [API requests and the object model](02-api-request-and-object-model.md)
