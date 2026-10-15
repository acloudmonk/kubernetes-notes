# Troubleshooting Security and Policy

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

Preserve exact context, principal, groups, verb, resource/subresource, namespace,
object, timestamp, response code/message, and audit correlation before editing a
binding or policy.

| Symptom | First separation | Evidence |
|---|---|---|
| 401 Unauthorized | missing/invalid/expired credential; issuer/audience/TLS | client auth config, token metadata without value, API/authenticator logs |
| 403 Forbidden | authenticated principal lacks authorization | response user, `auth can-i`, access review, Roles/Bindings, audit decision |
| RBAC says yes but write denied | admission, quota, schema, immutable field | API status reason/details, warning, policy/binding scope, quota usage |
| Policy unexpectedly skipped | namespace/object selector, operation, group/version/resource, binding | exact request and rendered policy/binding |
| Policy blocks everything | CEL error, missing parameter, failurePolicy Fail, broad match | `status.typeChecking`, API errors, audit annotations, recovery plan |
| Pod rejected as Restricted | one container/init/ephemeral field violates profile | admission message, complete Pod template, pinned profile version |
| Pod admitted but fails | runtime filesystem/UID/capability/seccomp incompatibility | container state/logs, events, runtime denial, image metadata |
| Token still mounted | Pod override, ServiceAccount setting, sidecar/projected volume | rendered Pod volumes/mounts, token audience/expiry metadata |
| Cross-tenant access | broad binding, operator/CRD, shared credential, network/storage gap | effective permissions, controller behavior, flows, volume/Secret ownership |

Do not “fix” a 403 with `cluster-admin` or a policy denial by disabling admission.
Find the first controlling boundary, repair the narrowest rule, retest intended
allows and denies, and inspect unintended privileges. Treat policy-controller
outage separately from an intentional denial.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
