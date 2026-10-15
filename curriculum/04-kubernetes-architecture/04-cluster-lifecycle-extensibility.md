# Lifecycle, Availability, and Extensibility

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Reconciliation, scheduling, and node execution](03-reconciliation-scheduling-node.md) ·
> Next: [Quick exercises](quick-exercises.md)

## Availability is a chain of dependencies

Control-plane availability includes the client-to-load-balancer path, API
servers, admission dependencies, and etcd quorum. A reachable API server can
still reject writes when an admission webhook times out or storage cannot
reach quorum. Existing containers may keep running during a control-plane
outage, but scheduling, controller repair, and most management operations stop.

Schedulers and controller managers use Lease-based leader election so multiple
replicas can be present without duplicating active control loops. Failover is
not instantaneous and does not repair a failed etcd quorum.

## etcd recovery is cluster recovery

etcd contains Kubernetes API state, so protect and test snapshots according to
the distribution's supported procedure. A copied data directory is not
automatically a valid backup. Encrypting Secret data at rest, protecting backup
keys, restricting snapshot access, and testing restore are separate controls.
Application databases and external resources require their own recovery plans;
an etcd snapshot does not back them up.

## Versions and compatibility

Kubernetes releases control-plane and node components independently within a
documented skew policy. `kubectl` is supported within one minor version of the
API server, but component-specific rules are more detailed. Upgrade one minor
at a time unless the distribution explicitly supports another path.

An API group can serve multiple versions while storing one version. Conversion
maps requests to the storage form and responses back to the requested form.
Deprecation removes neither risk nor stored objects: inventory manifests and
live requests, migrate clients, and verify that removed APIs are no longer used
before upgrading.

## Extension choices

- A **CustomResourceDefinition (CRD)** adds declarative API types through the
  main API server. A CRD alone stores data; a controller supplies behavior.
- An **aggregated API server** implements an API service behind the aggregation
  layer. It allows more API-server control but adds operational complexity.
- **Admission webhooks** mutate or validate API requests. They sit on a critical
  write path, so define timeouts, failure policy, availability, and recovery.
- A **controller/operator** reconciles built-in or custom resources. It needs
  least-privilege access, idempotency, status, upgrade, and deletion behavior.

Prefer built-in APIs and policy mechanisms when they express the requirement.
An extension creates a versioned API and an operational dependency that must be
owned for its entire lifecycle.

## Security boundaries

Protect kubeconfig files, service-account tokens, certificate authorities,
private keys, encryption configuration, audit logs, and etcd snapshots as
sensitive material. Base64-encoded Secret fields are not encryption. Use short-
lived identities where possible, least-privilege RBAC, restricted network
paths, admission safeguards, and an auditable break-glass process.

A kind cluster is intentionally convenient: its control plane and node state
live in Docker containers. It teaches component relationships but not a
production trust boundary, multi-zone availability, or cloud integration.

## Architecture decision questions

Before selecting a Kubernetes platform, record:

- supported versions, upgrade cadence, and deprecation visibility;
- control-plane and etcd responsibility, availability, backup, and restore;
- node images, runtime, autoscaling, patching, and disruption ownership;
- CNI, CSI, ingress/Gateway, DNS, identity, and policy integrations;
- observability, audit retention, incident access, and cost boundaries;
- recovery objectives for API state and application data.

## Review prompts

- Why can existing application containers survive an API-server outage?
- What behavior is missing when only a CRD has been installed?
- Why can a highly available admission webhook still become a cluster-wide risk?

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Reconciliation, scheduling, and node execution](03-reconciliation-scheduling-node.md) ·
> Next: [Quick exercises](quick-exercises.md)
