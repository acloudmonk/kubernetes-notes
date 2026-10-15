# Values, Schemas, and Dependencies

> **Module:** [11 — Helm](README.md) · Previous: [Charts, rendering, and release state](01-chart-rendering.md) · Next: [Lifecycle, hooks, migrations, and CRDs](03-lifecycle-hooks-crds.md)
## Values are an API

A values file is not merely a bag of variables. Users and automation depend on
its paths, types, defaults, and meaning. Prefer a small, nested, documented API:
group values by component, use consistent image/resource shapes, choose safe
defaults, and distinguish required input from optional tuning. Removing or
renaming a value is a breaking chart-interface change.

Values are merged by precedence: chart defaults, parent/dependency values,
files supplied with `-f`/`--values` in order, then `--set` family overrides.
Maps merge; list replacement can surprise users. `--set` parses types, so use
`--set-string` when a string that resembles a number or Boolean must remain a
string. Prefer reviewed values files over long shell expressions.

`--reuse-values` carries old release values forward and can preserve obsolete
configuration. For controlled promotion, render from explicit versioned inputs
and use `--reset-values` or the intended Helm 4 reset/reuse strategy consciously.

## Schema validation

`values.schema.json` rejects wrong types, invalid ranges, missing required
properties, and unknown keys before Kubernetes sees a manifest. It is both a
guardrail and executable documentation. Validate nested objects and use
`additionalProperties: false` where extension is not intended. Schema cannot
prove that a referenced Secret exists, a StorageClass is available, or the
application will become Ready; those require cluster-aware tests.

```powershell
# Expected to fail schema validation.
helm template cloudcart ./capstone/cloudcart/helm/cloudcart `
  --set-string config.relayIntervalSeconds=not-a-number
```

Templates should still fail clearly for context-dependent required values.
Schema errors should identify user input; template errors should identify chart
logic. Avoid encoding the same complex rule differently in both places.

## Dependencies

Dependencies are declared in `Chart.yaml`. `helm dependency update` resolves
ranges and writes `Chart.lock`; `helm dependency build` reproduces the locked
set. Commit the lock file when using dependencies, verify upstream provenance,
and review transitive templates and defaults. A subchart is executable supply
chain content, not a harmless library.

Parent charts configure subcharts beneath the dependency name or alias.
`global` values are visible broadly and create coupling; use them sparingly.
Conditions and tags can toggle dependencies, but every supported combination
needs validation. A library chart shares template primitives and renders no
workloads; excessive shared helpers can turn independent charts into a tightly
coupled framework.

CloudCart templates its local learning dependencies directly so the learner can
inspect every object. Production should use managed PostgreSQL and an explicitly
selected broker design rather than treating this topology as reusable HA.

## Secret values

Do not commit credentials in `values.yaml`, environment-specific values files,
rendered output, command history, chart archives, CI artifacts, or release
state. `--set` is not a secret manager: supplied values can be stored in Helm's
release record. Prefer a secret controller or deployment workflow that creates
or references a Secret without putting its value into the chart contract.

> **Module:** [11 — Helm](README.md) · Previous: [Charts, rendering, and release state](01-chart-rendering.md) · Next: [Lifecycle, hooks, migrations, and CRDs](03-lifecycle-hooks-crds.md)
