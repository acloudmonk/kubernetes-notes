# References and Videos

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module home](README.md)

## Primary written references

- [Terraform state](https://developer.hashicorp.com/terraform/language/state), [locking](https://developer.hashicorp.com/terraform/language/state/locking), and [sensitive data](https://developer.hashicorp.com/terraform/language/manage-sensitive-data)
- [Terraform test](https://developer.hashicorp.com/terraform/language/tests) and [configuration language style](https://developer.hashicorp.com/terraform/language/style)
- [OpenTofu documentation](https://opentofu.org/docs/) — verify compatibility against the selected release.
- [Kubernetes version-skew policy](https://kubernetes.io/releases/version-skew-policy/) and [deprecated API migration guide](https://kubernetes.io/docs/reference/using-api/deprecation-guide/)
- [Kubernetes disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/), [node autoscaling](https://kubernetes.io/docs/concepts/cluster-administration/node-autoscaling/), and [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- [Kubernetes production environment](https://kubernetes.io/docs/setup/production-environment/) and [large-cluster considerations](https://kubernetes.io/docs/setup/best-practices/cluster-large/)
- [Amazon EKS best-practices guide](https://docs.aws.amazon.com/eks/latest/best-practices/introduction.html), [Google GKE enterprise best practices](https://cloud.google.com/kubernetes-engine/enterprise/docs/best-practices), and [Azure AKS baseline architecture](https://learn.microsoft.com/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [Kubernetes API conventions: compatibility](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#compatibility)
- [Google SRE: incident management](https://sre.google/sre-book/managing-incidents/) and [postmortem culture](https://sre.google/sre-book/postmortem-culture/)

Provider documents describe different responsibility and service boundaries;
compare them rather than treating one architecture as portable fact.

## Videos

- [Is Your Kubernetes Disaster Recovery Actually Ready?](https://www.youtube.com/watch?v=21_7qv7J8GI) — Saiyam Pathak and Saloni Narang, CNCF/KubeCon, 2026. Tests the gap between backup artifacts and application-level recovery; current concepts, but verify named tool versions in written docs.
- [Disaster Recovery in Kubernetes](https://www.youtube.com/watch?v=IfyiMdaE_-Y) — CNCF, 2024. A useful recovery-design companion; commands and project maturity may have changed.
- [Velero resources and conference talks](https://velero.io/resources/) — Velero project/community, continuously updated. Choose a recent KubeCon session for practical backup and restore context; project docs remain authoritative.
- [Scaling with Terraform: the journey from startup to enterprise](https://www.hashicorp.com/en/resources/scaling-with-terraform-startup-enterprise) — HashiCorp, 2018. Still useful for state/team boundaries, but old product names and workflows require comparison with current Terraform documentation.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module home](README.md)
