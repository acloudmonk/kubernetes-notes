# API Access, Authentication, and Identity

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Module overview](README.md) · Next: [RBAC and privilege-escalation paths](02-rbac-least-privilege.md)

## The request path

For an API request, the API server authenticates a principal and groups,
authorizes request attributes, runs mutating then validating admission for an
eligible write, validates/defaults the object, and persists it. Authentication
failure is typically 401; an authenticated but unauthorized request is 403;
admission usually returns a descriptive 4xx rejection. Audit may record stages
such as request received, response started, and response complete.

TLS authenticates endpoints and protects transport; it does not decide whether
a principal may read Secrets or create Pods. Kubernetes does not provide a
general user database. Production human identity normally comes from an
external identity provider through OIDC or an authenticating proxy, with groups
mapped into authorization. Design joiner, mover, leaver, MFA, break-glass,
certificate/token revocation, and time-bound elevation—not just login.

## ServiceAccounts and tokens

A ServiceAccount is a namespaced workload identity. Assign one per workload
trust boundary rather than sharing `default`. Since Kubernetes 1.22, projected
bound tokens are short-lived, audience-bound, and Pod-bound; legacy static
Secret tokens should not be the default. Disable automount when no API access
is needed. If access is needed, request only the intended audience and expose
the token only to the consumer container.

Possession of a token is authority until expiry/revocation behavior takes
effect. Protect logs, exec/debug access, volumes, backups, node credentials,
and sidecars that can read the same filesystem. Never print a token for routine
verification; use impersonation or access-review APIs from an authorized admin.

CloudCart’s API, relay, and worker receive distinct ServiceAccounts with token
automount disabled. They need network identities for databases and brokers, but
they do not call the Kubernetes API, so RBAC grants would add risk without value.

## Workload identity beyond Kubernetes

Cloud workload identity federation exchanges a signed ServiceAccount token for
a scoped, short-lived cloud identity. Bind namespace, ServiceAccount, audience,
issuer, and cloud role narrowly. Avoid node-wide instance credentials that any
compromised Pod can reach. Validate issuer discovery, JWKS/key rotation, token
audience, clock skew, egress, cloud audit, and failure behavior.

Identity proves *who*; RBAC/policy decide *what*; network policy controls *where*;
application authorization decides business actions. Do not collapse them.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Module overview](README.md) · Next: [RBAC and privilege-escalation paths](02-rbac-least-privilege.md)
