# References and Videos

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

## Primary references

- [Kubernetes configuration](https://kubernetes.io/docs/concepts/configuration/), [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/), and [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Good practices for Kubernetes Secrets](https://kubernetes.io/docs/concepts/security/secrets-good-practices/) and [security checklist](https://kubernetes.io/docs/concepts/security/security-checklist/)
- [Encrypting confidential API data at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)
- [Projected volumes](https://kubernetes.io/docs/concepts/storage/projected-volumes/) and [RBAC good practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)
- [Secrets Store CSI Driver](https://secrets-store-csi-driver.sigs.k8s.io/) and [auto rotation](https://secrets-store-csi-driver.sigs.k8s.io/topics/secret-auto-rotation)
- [External Secrets Operator documentation](https://external-secrets.io/latest/)

## Videos

- [Secrets Store CSI Driver: Keeping Secrets Secret](https://www.youtube.com/watch?v=w0k7MI6sCJg) — Anish Ramasekar and Tommy Murphy, CNCF/KubeCon, 2021. Use it to compare external-store mounts, provider identity, and rotation. **Age warning:** confirm current driver flags, providers, and rotation behavior in upstream docs.
- [Secrets Store CSI Driver — Bring Your Own Enterprise Secrets Store to Kubernetes](https://www.youtube.com/watch?v=bIC4kLnrKN0) — Rita Zhang, CNCF/KubeCon, 2019. Use it for the CSI/provider architecture and threat boundary. **Age warning:** APIs and maturity have evolved; current project documentation is authoritative.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
