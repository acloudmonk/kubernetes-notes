# References and Videos

> **Module:** [12 — Prometheus](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

## Primary references

- [Prometheus overview](https://prometheus.io/docs/introduction/overview/), [data model](https://prometheus.io/docs/concepts/data_model/), and [metric types](https://prometheus.io/docs/concepts/metric_types/)
- [Instrumentation practices](https://prometheus.io/docs/practices/instrumentation/), [naming](https://prometheus.io/docs/practices/naming/), and [histograms and summaries](https://prometheus.io/docs/practices/histograms/)
- [Configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) and [Kubernetes service discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kubernetes_sd_config)
- [PromQL basics](https://prometheus.io/docs/prometheus/latest/querying/basics/), [operators](https://prometheus.io/docs/prometheus/latest/querying/operators/), and [functions](https://prometheus.io/docs/prometheus/latest/querying/functions/)
- [Recording rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/), [alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/), and [rule unit tests](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/)
- [Alerting overview](https://prometheus.io/docs/alerting/latest/overview/), [Alertmanager configuration](https://prometheus.io/docs/alerting/latest/configuration/), and [high availability](https://prometheus.io/docs/alerting/latest/alertmanager/#high-availability)
- [Storage](https://prometheus.io/docs/prometheus/latest/storage/), [federation](https://prometheus.io/docs/prometheus/latest/federation/), and [remote write tuning](https://prometheus.io/docs/practices/remote_write/)
- [Prometheus security model](https://prometheus.io/docs/operating/security/) and [release cycle](https://prometheus.io/docs/introduction/release-cycle/)
- [Python client documentation](https://prometheus.github.io/client_python/) and [Prometheus HTTP API](https://prometheus.io/docs/prometheus/latest/querying/api/)
- [Prometheus Operator design and CRDs](https://prometheus-operator.dev/docs/getting-started/design/)

## Videos

- [Introduction to Prometheus, PromQL, and PromLens](https://rawkode.academy/watch/introduction-to-prometheus-promql-and-promlens) — Julius Volz, 2020. Strong data-model, metric-type, scrape, and query walkthrough. **Age warning:** UI, versions, and native-histogram capabilities have evolved; use current docs for syntax and operations.
- [PromQL for Mere Mortals](https://www.youtube.com/watch?v=hTjHuoWxsks) — PromCon, 2019. Use it for vector/range and aggregation mental models. **Age warning:** confirm functions and UI against Prometheus 3 documentation.
- [Best Practices and Beastly Pitfalls](https://promcon.io/2017-munich/talks/best-practices-and-beastly-pitfalls/) — Julius Volz, PromCon 2017. Use it for durable design principles. **Age warning:** many operational features and ecosystem components predate Prometheus 3.
- [Taming Metric Cardinality](https://www.youtube.com/watch?v=DH6mIzqG3aQ) — CNCF/KubeCon, 2025. Use it for modern cardinality reduction thinking across Prometheus and OpenTelemetry. **Scope warning:** Collector-specific mechanisms are expanded in Module 13.
- [Inside Prometheus 3.0](https://grafana.com/blog/-grafanas-big-tent-podcast-prometheus-3.0-native-histograms-and-the-future-of-metrics/) — Prometheus maintainers, 2025. Use it for project history and Prometheus 3/native-histogram context. **Age warning:** the lab baseline is newer; current release notes are authoritative.

Treat videos as conceptual reinforcement. Verify all version-sensitive claims
against primary documentation and the tested baseline.

> **Module:** [12 — Prometheus](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
