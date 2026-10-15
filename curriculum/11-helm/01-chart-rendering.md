# Charts, Rendering, and Release State

> **Module:** [11 — Helm](README.md) · Previous: [Module overview](README.md) · Next: [Values, schemas, and dependencies](02-values-schema-dependencies.md)
## The mental model

A **chart** is a versioned package of templates, default values, metadata, and
optional dependencies. A **release** is one installation of a chart in a
cluster. Each install, upgrade, or rollback produces a **revision**. The same
chart can therefore create many releases with different names, namespaces, and
values.

Helm is not a controller continuously reconciling the chart source. The client
loads the chart and values, evaluates Go templates into Kubernetes YAML, sends
objects to the API, and stores release state in the cluster—normally in Secrets.
Kubernetes controllers then reconcile those objects. If someone changes a live
object later, a CLI-managed release does not repair it until another Helm action.

Helm 4 uses server-side apply for new releases by default. The API server's
schema, admission chain, defaulting, field management, and controllers still
decide what the cluster accepts and runs. A successful render is not proof of a
successful deployment.

## Chart anatomy

- `Chart.yaml` declares chart identity, chart version, application version, and dependencies.
- `values.yaml` is the documented default configuration contract.
- `values.schema.json` validates the merged values before rendering.
- `templates/` contains templates and named helpers; underscore-prefixed files do not render objects.
- `templates/NOTES.txt` gives post-install guidance, not executable guarantees.
- `templates/tests/` conventionally holds Pods or Jobs invoked by `helm test`.
- `.helmignore` excludes irrelevant files from a packaged archive.

Chart `version` identifies the package and must change when chart behavior
changes. `appVersion` describes the packaged application and is informational;
do not derive correctness from it or assume it is a container tag.

## Template execution

Go template actions run inside YAML text. `.` is the current scope; `$` retains
the root. Built-ins such as `.Values`, `.Release`, `.Chart`, and `.Capabilities`
provide input. Named templates centralize labels and names. Functions such as
`required`, `default`, `quote`, `toYaml`, `nindent`, and `include` help construct
valid output.

Whitespace and type errors can produce valid-looking but incorrect YAML. Keep
logic shallow, prefer maps over positional lists, pass explicit context to
helpers, quote strings at the YAML boundary, and inspect output. Do not template
every field merely because Helm permits it; expose only supported decisions.

```powershell
helm lint ./capstone/cloudcart/helm/cloudcart --strict
helm template cloudcart ./capstone/cloudcart/helm/cloudcart `
  --namespace cloudcart --debug
```

`lookup` can read cluster state while rendering against a cluster, which makes
output environment-dependent and harder to test. Use it only for a documented
requirement. Never use templates to generate a secret once and assume future
renders can recover it safely.

## Names and ownership

Names should be deterministic, DNS-safe, and collision-aware. Standard labels
identify application, instance, version, component, and manager. Helm ownership
metadata identifies resources belonging to a release. Do not silently adopt an
existing resource: establish who owns it, migrate deliberately, or keep it
external.

CloudCart keeps `cloudcart-credentials` outside the release. Uninstalling or
rolling back the chart therefore cannot delete or reconstruct the secret. The
tradeoff is an explicit prerequisite and separate lifecycle.

> **Module:** [11 — Helm](README.md) · Previous: [Module overview](README.md) · Next: [Values, schemas, and dependencies](02-values-schema-dependencies.md)
