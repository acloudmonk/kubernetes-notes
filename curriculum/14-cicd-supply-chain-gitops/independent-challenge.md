# Independent Challenge

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Lab 2](labs/02-reconcile-drift-recover.md) · Next: [Troubleshooting](troubleshooting.md)

Design a two-environment CloudCart promotion flow without copying mutable tags or
plaintext secrets. Produce an image digest, CycloneDX or SPDX SBOM, vulnerability
decision, signature/provenance verification, immutable Helm package identity,
reviewed promotion change, and Flux reconciliation evidence.

## Constraints

- build once and promote the same digest;
- use short-lived identities and separate publish from deploy authority;
- deploy through Flux, not a CI cluster credential;
- define an expiring vulnerability exception and one admission denial;
- demonstrate drift repair and bad-release recovery;
- preserve database compatibility and the order → outbox → broker → worker path;
- keep credentials, private keys, generated evidence, and scanner databases out of Git.

## Acceptance evidence

Submit the source revision, artifact/checksum identities, verification outputs,
Flux conditions/revision, application transaction proof, controlled failure
timeline, recovery proof, cleanup, and a short threat model of the delivery path.

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Lab 2](labs/02-reconcile-drift-recover.md) · Next: [Troubleshooting](troubleshooting.md)
