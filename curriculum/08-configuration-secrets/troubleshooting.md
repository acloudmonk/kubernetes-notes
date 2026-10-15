# Troubleshooting Configuration and Secrets

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

## Evidence without exposure

Inspect context, namespace, object/Pod names, UIDs, generations,
resourceVersions, keys (not values), references, events, rollout revisions,
readiness, sanitized application errors, backend audit/version metadata, and a
representative business transaction. Avoid `kubectl get secret -o yaml`, decoded
output, full environments, command traces, support bundles, and screenshots that
contain values.

| Symptom | Boundary | Evidence/correction |
|---|---|---|
| `CreateContainerConfigError` | reference/key | Pod events, object/key existence, optional flag, namespace |
| ConfigMap changed, process stale | delivery semantics | env needs restart; volume is eventual; application may need reload |
| Mounted file never changes | mount/reload | check `subPath`, kubelet projection, symlink-aware watcher, immutable flag |
| New Pods fail authentication | backend/source drift | compare versions/audit, rotation ordering, restore or publish correct version |
| Some replicas use old value | mixed rollout | Pod UIDs/start times/template revision, pools/caches, staged convergence |
| External provider unavailable | identity/provider/driver | workload identity, provider audit, controller/CSI events, cached-value policy |
| Secret access denied | authorization | service account, Role/Binding, exact verb/resource/name; do not grant broad list |
| Secret appears in logs | handling incident | contain access, rotate/revoke first, purge per policy, fix redaction/path |

If a real value is exposed, treat it as compromised: revoke or rotate it before
cleaning output or Git history. Deleting the visible copy does not invalidate the
credential or erase replicas, caches, logs, backups, and clones.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
