# Knowledge Check

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

1. Is base64 encryption?
2. Does changing a ConfigMap update existing environment variables?
3. Do normal ConfigMap/Secret volume files update instantly?
4. Does a `subPath` projection receive automated updates?
5. Can a user without Secret `get` necessarily be considered unable to read it?
6. What does `optional: true` change?
7. Can an immutable Secret later become mutable?
8. Does API-server encryption prevent authorized `get` from returning plaintext?
9. Why can a rollout succeed while credential rotation failed?
10. What is the advantage of overlapping credentials?
11. When does external-secret synchronization still store data in etcd?
12. What should happen first after a real credential reaches a repository?

---

## Answers

1. No; it is reversible encoding.
2. No; containers receive their environment at start and need replacement/reload design.
3. No; propagation is eventually consistent and applications must reopen/reload.
4. No.
5. No; Pod creation/debug/privileged node paths may provide indirect access.
6. The Pod may start without the object/key; the application must safely handle absence.
7. No; replace the object and recreate consumers.
8. No; it protects stored representation, not authorized API responses.
9. Pods may hold a value the backend rejects, or old pools/caches may hide drift.
10. Consumers can migrate and be verified before old access is revoked.
11. When the controller materializes the provider value as a Kubernetes Secret.
12. Revoke or rotate it, then assess exposure and clean history/logs according to policy.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
