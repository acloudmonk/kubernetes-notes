# References and Videos

> **Module:** [11 — Helm](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

## Primary references

- [Helm 4 documentation](https://helm.sh/docs/) and [Helm 4 overview](https://helm.sh/docs/topics/helm4/)
- [Charts](https://helm.sh/docs/topics/charts/), [chart best practices](https://helm.sh/docs/chart_best_practices/), and the [chart template guide](https://helm.sh/docs/chart_template_guide/)
- [Values files](https://helm.sh/docs/chart_template_guide/values_files/) and [schema files](https://helm.sh/docs/topics/charts/#schema-files)
- [Template functions and pipelines](https://helm.sh/docs/chart_template_guide/functions_and_pipelines/) and [named templates](https://helm.sh/docs/chart_template_guide/named_templates/)
- [`helm install`](https://helm.sh/docs/helm/helm_install/), [`helm upgrade`](https://helm.sh/docs/helm/helm_upgrade/), and [`helm rollback`](https://helm.sh/docs/helm/helm_rollback/)
- [Chart hooks](https://helm.sh/docs/topics/charts_hooks/), [chart tests](https://helm.sh/docs/topics/chart_tests/), and [CRD best practices](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/)
- [Dependencies](https://helm.sh/docs/helm/helm_dependency/) and [OCI registries](https://helm.sh/docs/topics/registries/)
- [Provenance and integrity](https://helm.sh/docs/topics/provenance/) and [security](https://helm.sh/docs/topics/security/)
- [Kubernetes server-side apply](https://kubernetes.io/docs/reference/using-api/server-side-apply/) and [recommended labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)

## Related delivery references

- [Flux Helm controller](https://fluxcd.io/flux/components/helm/) and [Argo CD Helm guide](https://argo-cd.readthedocs.io/en/stable/user-guide/helm/)
- [OCI Distribution Specification](https://github.com/opencontainers/distribution-spec)
- [Artifact Hub security report](https://artifacthub.io/docs/topics/security_report/) for evaluating published packages

## Videos

- [Helm 4 You](https://www.youtube.com/watch?v=rdTPbm9f_fc) — Helm maintainers at KubeCon/CNCF, 2025. Use it for the Helm 4 direction and design motivations. **Age warning:** it predates the final Helm 4 release; current Helm 4 docs are authoritative for commands and behavior.
- [From improving Helm to developing Nelm](https://www.cncf.io/online-programs/cncf-on-demand-webinar-from-improving-helm-to-developing-nelm-the-evolution-of-deployments-in-werf/) — CNCF webinar, 2024. Use it for a critical view of release and deployment edge cases. **Age warning:** it presents another tool's design position, not Helm's normative behavior.
- [Policy as code: what Helm developers need to know about security](https://www.cncf.io/online-programs/cncf-on-demand-webinar-policy-as-code-what-helm-developers-need-to-know-about-security/) — CNCF webinar, 2021. Use it for threat-model prompts. **Age warning:** verify products, APIs, and scanning guidance against current primary documentation.
- [Kubernetes infrastructure the GitOps way](https://www.cncf.io/online-programs/cncf-on-demand-webinar-kubernetes-infrastructure-the-gitops-way/) — CNCF webinar, 2022. Use it to compare imperative release operations with reconciliation. **Age warning:** controller details evolve; consult current Flux or Argo CD docs.

Treat videos as conceptual reinforcement. Record version-sensitive claims and
resolve them against primary documentation and the tested baseline.

> **Module:** [11 — Helm](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
