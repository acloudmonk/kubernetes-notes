# 11 — Helm

**Status:** Verified<br>
**Estimated time:** 24–30 hours<br>
**Prerequisites:** [10 — Kubernetes Security and Policy](../10-security-policy/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Security and policy](../10-security-policy/README.md) · Next: [Prometheus](../12-prometheus/README.md)

## Why this matters

Plain manifests describe Kubernetes objects; Helm adds a reusable packaging,
configuration, release, and distribution contract. That convenience also adds
failure modes: unsafe values, hidden rendered changes, hook ordering, ownership
conflicts, leaked credentials, and false confidence in rollback. A capable Helm
operator can predict the YAML and Kubernetes behavior behind every release.

## Learning objectives

You can explain charts, releases, revisions, release state, and Helm 4's
server-side apply workflow; design a stable values contract and JSON schema;
write maintainable templates; validate rendered output; install, upgrade,
diagnose, test, and roll back releases; handle migrations, CRDs, secrets, and
dependencies safely; package and distribute immutable charts through OCI; and
reason about Helm when a GitOps controller is the release operator.

## Contents

1. [Charts, rendering, and release state](01-chart-rendering.md)
2. [Values, schemas, and dependencies](02-values-schema-dependencies.md)
3. [Lifecycle, hooks, migrations, and CRDs](03-lifecycle-hooks-crds.md)
4. [Testing, distribution, security, and GitOps](04-testing-distribution-gitops.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Author and validate the CloudCart chart](labs/01-author-validate-chart.md)
7. [Lab 2 — Upgrade, fail, and roll back](labs/02-upgrade-fail-rollback.md)
8. [Independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)

## Tested baseline

The labs target Helm 4.3.1, kind 0.33.0, and Kubernetes 1.36.4. The first-party
CloudCart chart packages the API, relay, worker, migration Job, PostgreSQL, and
RabbitMQ. Credentials are generated directly in the cluster and referenced as
an externally owned Secret. Verification covers strict linting, schema failure,
rendering, server-side validation, install, chart test, configuration rollout,
an intentionally failed upgrade, rollback, application data flow, packaging,
repeat execution, and precise cleanup.

PostgreSQL and RabbitMQ are single-instance learning dependencies. The chart is
not a production HA data platform.

## Completion

- [ ] **Explain:** trace values through rendering, release storage, API apply, and reconciliation.
- [ ] **Build:** author a schema-validated, testable, packageable chart without embedding credentials.
- [ ] **Diagnose:** recover a failed upgrade using rendered output, events, workload state, and release history.
- [ ] **Design:** justify migration, CRD, dependency, versioning, ownership, and GitOps choices.
- [ ] Complete the independent challenge.
- [ ] Pass [Gate 3 — Kubernetes platform practitioner](../ASSESSMENT-GATES.md#gate-3--kubernetes-platform-practitioner).

## Continue

After recording Gate 3 evidence, continue to
[Module 12 — Prometheus](../12-prometheus/README.md), or return to the
[curriculum index](../README.md).
