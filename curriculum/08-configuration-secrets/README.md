# 08 — Kubernetes Configuration and Secrets

**Status:** Verified<br>
**Estimated time:** 22–28 hours<br>
**Prerequisites:** [07 — Kubernetes Storage and State](../07-storage-state/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Storage and state](../07-storage-state/README.md) · Next: [Scheduling and resources](../09-scheduling-resources/README.md)

## Why this matters

The same image should run across environments without rebuilding, but every
configuration path creates rollout, validation, security, and ownership
questions. Secrets add a threat model: base64 is not encryption, API access can
be indirect, and changing a value does not prove applications or backends have
rotated safely.

## Learning objectives

You can classify configuration, choose ConfigMap/Secret consumption modes,
predict update behavior, design least-exposure RBAC and encryption, compare
external-store integration patterns, rotate credentials with recovery steps,
and diagnose missing/stale configuration without revealing values.

## Contents

1. [Configuration design and ConfigMaps](01-configuration-design.md)
2. [Secrets, threat model, and cluster controls](02-secrets-threat-model.md)
3. [Consumption and update semantics](03-consumption-update-semantics.md)
4. [External stores and rotation](04-external-stores-rotation.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Observe configuration lifecycle](labs/01-observe-configuration.md)
7. [Lab 2 — Diagnose and rotate safely](labs/02-diagnose-rotate.md)
8. [Independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)

## Tested baseline

Uses the verified Module 07 CloudCart storage baseline on kind 0.33.0 and
Kubernetes 1.36.4. Credentials are generated in the disposable cluster, kept
out of command output and Git, and cleared from script variables after use.
The lab installs no external secret controller and claims no etcd encryption;
those platform patterns are analyzed from upstream interfaces and evidence.

## Completion

- [ ] **Explain:** classify configuration and predict each delivery method's update behavior.
- [ ] **Build:** consume non-secret and secret values without committing credentials.
- [ ] **Diagnose:** use events to isolate a missing required Secret.
- [ ] **Rotate:** coordinate backend, Secret, rollout, verification, and recovery.
- [ ] Complete the independent challenge.

## Continue

Continue to [09 — Kubernetes Scheduling and Resources](../09-scheduling-resources/README.md), or return to the [curriculum index](../README.md).
