# 10 — Kubernetes Security and Policy

**Status:** Verified<br>
**Estimated time:** 24–30 hours<br>
**Prerequisites:** [09 — Kubernetes Scheduling and Resources](../09-scheduling-resources/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Scheduling and resources](../09-scheduling-resources/README.md) · Next: Helm (planned)

## Why this matters

Kubernetes security is a chain of trust, not one setting. Identity, API
authorization, admission, Pod isolation, node/runtime hardening, network and
storage controls, secrets, supply chain, audit, and recovery must reinforce one
another. A permissive link can turn ordinary deployment access into secret
theft, node compromise, or cross-tenant impact.

## Learning objectives

You can trace an API request through authentication, authorization, admission,
and persistence; design least-privilege RBAC; use short-lived workload identity;
apply Restricted Pod Security controls; write and stage native CEL admission
policy; reason about tenant boundaries and privilege escalation; and diagnose a
403, admission denial, or runtime security failure from evidence.

## Contents

1. [API access, authentication, and identity](01-api-access-identity.md)
2. [RBAC and privilege-escalation paths](02-rbac-least-privilege.md)
3. [Workload, node, and runtime security](03-workload-runtime-security.md)
4. [Admission policy and multi-tenancy](04-admission-multitenancy.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Establish identities and least privilege](labs/01-identity-rbac.md)
7. [Lab 2 — Enforce workload and admission policy](labs/02-admission-boundary.md)
8. [Independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)

## Tested baseline

The lab targets kind 0.33.0 and Kubernetes 1.36.4. It composes the verified
Module 08 CloudCart baseline, assigns dedicated tokenless ServiceAccounts, and
uses an isolated namespace for Restricted Pod Security Admission, namespace
RBAC, quota, and stable `admissionregistration.k8s.io/v1` CEL validation. The
deployment and test scripts passed twice, including expected denial paths and
server-side validation.

## Completion

- [ ] **Explain:** map every API and runtime trust boundary and its owner.
- [ ] **Build:** implement least privilege, token minimization, Pod Security, and admission policy.
- [ ] **Diagnose:** distinguish authentication, authorization, admission, scheduling, and runtime denial.
- [ ] **Threat-model:** identify direct and indirect privilege-escalation paths.
- [ ] Complete the independent challenge.

## Continue

Return to the [curriculum index](../README.md). Module 11 will be linked when
the Helm material is available.
