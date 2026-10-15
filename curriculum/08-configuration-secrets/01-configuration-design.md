# Configuration Design and ConfigMaps

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Module overview](README.md) · Next: [Secrets, threat model, and cluster controls](02-secrets-threat-model.md)

## Classify before choosing an API

Separate build-time code/dependencies from deploy-time environment configuration,
runtime control-plane configuration, dynamic business data, and confidential
material. ConfigMaps store small non-confidential strings/binary data; Secrets
signal confidential intent but require additional controls. Large or frequently
mutated data belongs in an appropriate service, not the Kubernetes API.

Record for every key: owner, schema/type, default, required/optional status,
scope, sensitivity, source of truth, consumers, reload mechanism, rollout and
rollback, audit needs, and failure behavior. Configuration is an API contract;
unknown keys, invalid ranges, and contradictory settings should fail early.

## ConfigMap mechanics

ConfigMaps are namespaced objects with `data` (UTF-8 strings) and `binaryData`
(base64-serialized bytes) and a 1 MiB limit. They can supply environment
variables, command arguments, or volume files. They do not provide secrecy or
encryption. Object metadata, manifests, events, Git history, rendered templates,
CI logs, and application logs are all potential exposure paths.

Avoid a giant shared ConfigMap. Give objects a coherent lifecycle and consumers;
otherwise one change creates unrelated rollouts and broad read access. Keep
environment differences as data, not duplicated workload definitions, and
validate before deployment.

## Precedence and reproducibility

Define precedence explicitly, for example command-line flag → environment →
file → safe default. Kubernetes does not resolve application-level conflicts.
`env` entries override duplicate keys from `envFrom`; later source collisions
can be subtle and invalid environment names may be skipped with events.

Two common rollout strategies are:

- mutable object plus an explicit restart/reload after successful validation;
- versioned or immutable object names referenced by a changed Pod template.

Template checksum annotations are common in Helm, but plain Kubernetes does not
automatically restart Pods when a referenced ConfigMap changes. Kustomize name
suffix hashes can make the reference/version explicit. Whichever strategy is
used, retain enough previous state to roll back and avoid unbounded stale objects.

## Dynamic configuration

Hot reload requires an application contract: watch/poll/notification, atomic
parsing, validation, last-known-good behavior, observability, and concurrency
safety. Updating a mounted file is not equivalent to the application reopening
or accepting it. For risky changes use staged exposure, feature flags with
ownership/expiry, or a dedicated configuration service rather than treating the
Kubernetes API as a real-time control bus.

CloudCart reads settings once at process start from environment variables. The
lab therefore proves that updating `cloudcart-config` does not change the
existing relay and that a controlled rollout is required.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Module overview](README.md) · Next: [Secrets, threat model, and cluster controls](02-secrets-threat-model.md)
