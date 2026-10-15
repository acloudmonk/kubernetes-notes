# ADR 0008: Use native security policy as the minimum baseline

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

CloudCart needs portable workload-security and admission guardrails without
making every cluster depend immediately on a third-party policy controller.
Pod Security Admission and ValidatingAdmissionPolicy are stable, built into the
Kubernetes API server, and sufficient for a meaningful minimum boundary. They
do not cover every inventory, mutation, external-data, reporting, or
supply-chain requirement.

## Decision

Use pinned Restricted Pod Security Admission for compatible application
namespaces, introduced through warn/audit before enforce. Use narrowly scoped,
tested ValidatingAdmissionPolicy rules for simple field-based invariants. Use
dedicated ServiceAccounts, disable token automount when the API is unnecessary,
and grant only namespaced, reviewed RBAC required by actual behavior.

Adopt Kyverno, OPA Gatekeeper, or another controller only when documented
requirements exceed native policy. That decision must include availability,
certificate, upgrade, reporting, failure-policy, bootstrap, recovery, and
break-glass design. Admission does not replace image provenance, network/storage
isolation, runtime security, audit, or incident response.

## Consequences

The minimum baseline has fewer moving parts and is portable across conformant
clusters. Policy authors must understand CEL and Kubernetes admission semantics.
Native rules offer less workflow/reporting breadth than a dedicated engine, and
third-party images may require staged remediation or isolated exceptions.

## Validation

- Test intended create/update allows, denies, selector scope, CEL type checking,
  and failure behavior before enforcement.
- Prove workload API access from effective RBAC and token mounts, not manifest
  intent alone.
- Exercise policy rollback and cluster recovery without leaving an unobserved
  fail-open window.
- Re-evaluate profile versions, controls, exemptions, and policy-engine need
  during every Kubernetes upgrade.
