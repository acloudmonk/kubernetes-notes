# Workload, Node, and Runtime Security

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [RBAC and privilege-escalation paths](02-rbac-least-privilege.md) · Next: [Admission policy and multi-tenancy](04-admission-multitenancy.md)

## Pod security controls

Start with a non-root image and make intent explicit: `runAsNonRoot`, fixed UID
when appropriate, `allowPrivilegeEscalation: false`, drop all capabilities,
`seccompProfile: RuntimeDefault`, read-only root filesystem, and narrowly scoped
writable volumes. Avoid privileged mode, host namespaces, hostPath, host ports,
unsafe sysctls, device access, and added capabilities unless a documented system
workload requires them.

These controls are related but not interchangeable. A non-root UID can still
hold dangerous capabilities; read-only root does not protect writable mounted
data; seccomp reduces syscall surface but is not an authorization system; and
`allowPrivilegeEscalation: false` blocks gaining more privilege through exec but
does not remove privileges already granted.

Pod Security Standards define Privileged, Baseline, and Restricted profiles.
Pod Security Admission applies them by namespace in `enforce`, `audit`, and
`warn` modes, optionally pinned to a Kubernetes minor version. Stage migration:
inventory → warn/audit → remediate → enforce → continuously test. Enforce acts
on Pods; warning/audit also help surface controller-template violations.

## Runtime and node boundary

Containers share a kernel. Harden kubelet/API endpoints, OS, container runtime,
kernel, and node credentials; minimize packages and SSH; patch promptly; encrypt
disks and backups; restrict metadata services; and separate higher-risk
workloads onto dedicated pools or stronger sandboxes. Node compromise can expose
Pods, volumes, image layers, and credentials scheduled there.

Use SELinux/AppArmor where supported for mandatory access control. RuntimeClass
can select sandboxed runtimes for stronger isolation at compatibility and cost.
Runtime detection (for example Falco-style syscall/event rules) supplies
evidence, not prevention by itself. Define alert ownership, tuning, forensic
retention, containment, credential rotation, node quarantine/rebuild, and data
recovery before an incident.

## Images and processes

Pin reproducible image identity, scan vulnerabilities and malware, minimize
contents, generate SBOM/provenance, sign artifacts, restrict registries, and
verify policy at promotion/admission. Module 14 implements the full supply-chain
path. An admission image rule does not prove an image is benign; it only proves
the submitted reference met that rule.

Do not log Secrets, tokens, environment dumps, or request credentials. Treat
`exec`, debug containers, core dumps, and diagnostic archives as privileged
operations with retention and audit controls.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [RBAC and privilege-escalation paths](02-rbac-least-privilege.md) · Next: [Admission policy and multi-tenancy](04-admission-multitenancy.md)
