# Secrets, Threat Model, and Cluster Controls

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Configuration design and ConfigMaps](01-configuration-design.md) · Next: [Consumption and update semantics](03-consumption-update-semantics.md)

## A Secret is an API object, not a complete vault

Kubernetes Secret values are base64-encoded in API serialization; base64 is
reversible and provides no confidentiality. Secrets are stored unencrypted in
etcd by default unless the cluster configures resource encryption. TLS protects
API traffic, not necessarily stored etcd data or its backups.

Threat-model source creation, Git/CI/rendered output, API/etcd access, admission
webhooks, audit/logging, node/kubelet/runtime access, container/process exposure,
application logs/crash dumps, backups, operators, and the external system that
accepts the credential. Redaction in one CLI is not end-to-end protection.

## Authorization realities

Restrict Secret `get`, `list`, and `watch`; listing returns values. Namespace
boundaries help but do not isolate users who can create or mutate Pods: someone
who can schedule a Pod in a namespace can usually arrange for that Pod to consume
namespace Secrets. Privileged containers and node administrators can access
secrets used on that node. Protect workload creation, exec/debug, ephemeral
containers, RBAC escalation, admission, and nodes—not only the Secret resource.

Prefer delivery to the one container that needs a value. Disable automatic
service-account token mounting when unused; use short-lived bound workload
identity instead of static cloud keys when supported. Separate duties for secret
administration, workload deployment, key management, and audit.

## Encryption at rest

Configure API-server encryption with a strong provider and protect/rotate its
keys separately. Verify which resources are covered and rewrite existing objects
so old plaintext data is encrypted. Encrypt etcd backups and transport, restrict
etcd access, and test key rotation/recovery. An encryption config whose keys sit
unprotected beside the data only shifts the problem.

Envelope KMS integration can keep key-encryption operations in an external key
service. Availability, latency, caching, key deletion, disaster recovery, and
provider permissions then become control-plane dependencies.

## Creation and handling

Do not commit real Secret YAML, even with `data`. Prefer a trusted delivery
pipeline, external store, or direct imperative creation from protected inputs.
Avoid command history, process arguments, terminal output, debug traces, and
temporary files. Validate keys without decoding values where possible; when a
value must be handled, minimize lifetime and clear memory variables best-effort.

Secret types add validation/intention for TLS, registry credentials, tokens, and
other well-known formats, but type alone does not secure contents. The 1 MiB
object limit and API-distribution model also make Secrets unsuitable for large
artifacts.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Configuration design and ConfigMaps](01-configuration-design.md) · Next: [Consumption and update semantics](03-consumption-update-semantics.md)
