# References and Videos

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

## Primary references

- [OpenTelemetry concepts](https://opentelemetry.io/docs/concepts/), [signals](https://opentelemetry.io/docs/concepts/signals/), and [context propagation](https://opentelemetry.io/docs/concepts/context-propagation/)
- [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/), [configuration](https://opentelemetry.io/docs/collector/configuration/), and [deployment patterns](https://opentelemetry.io/docs/collector/deployment/)
- [OpenTelemetry Python instrumentation](https://opentelemetry.io/docs/languages/python/instrumentation/) and [exporters](https://opentelemetry.io/docs/languages/python/exporters/)
- [OpenTelemetry semantic conventions](https://opentelemetry.io/docs/specs/semconv/) and [W3C Trace Context](https://www.w3.org/TR/trace-context/)
- [Grafana provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/), [dashboard best practices](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/best-practices/), and [security](https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/)
- [Loki concepts](https://grafana.com/docs/loki/latest/get-started/overview/), [labels](https://grafana.com/docs/loki/latest/get-started/labels/), [LogQL](https://grafana.com/docs/loki/latest/query/), and [native OTLP ingestion](https://grafana.com/docs/loki/latest/send-data/otel/)
- [Tempo overview](https://grafana.com/docs/tempo/latest/), [architecture](https://grafana.com/docs/tempo/latest/operations/architecture/), [TraceQL](https://grafana.com/docs/tempo/latest/traceql/), and [local deployment](https://grafana.com/docs/tempo/latest/set-up-for-tracing/setup-tempo/deploy/locally/linux/)
- [Grafana trace-to-logs correlation](https://grafana.com/docs/grafana/latest/datasources/tempo/configure-tempo-data-source/configure-trace-to-logs/) and [Prometheus exemplars](https://prometheus.io/docs/prometheus/latest/feature_flags/#exemplars-storage)
- [Google SRE Workbook: Implementing SLOs](https://sre.google/workbook/implementing-slos/) and [Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/)
- [OpenSLO specification](https://openslo.com/) for a vendor-neutral SLO model

## Videos

- [Exploring logs, metrics, and traces with Grafana](https://www.youtube.com/watch?v=1q3YzX2DDM4) — Grafana, 2024. A compact Explore workflow before the deeper lab. **Version note:** navigation can differ in Grafana 13.
- [Mastering OpenTelemetry Collector Configuration](https://www.youtube.com/watch?v=vzJpDNfA5xU) — CNCF/KubeCon, 2024. Focus on receiver/processor/exporter design and configuration failure modes. **Version note:** confirm component schemas against Collector 0.160.0 docs.
- [OpenTelemetry Looks Good To Me: Loki, Grafana, Tempo, Mimir](https://grafana.com/events/grafanacon/2024/opentelemetry-with-grafana-lgtm-stack/) — GrafanaCON, 2024. Reinforces the vendor-neutral signal path and LGTM roles.
- [Reducing MTTR with Prometheus, Loki, and Tempo](https://grafana.com/go/webinar/opinionated-observability-stack-prometheus-loki-tempo/) — Grafana Labs, 2021. Use it for the metrics → logs → traces investigation pattern. **Age warning:** product UI and configuration are older than this lab.
- [How to get started with OpenTelemetry and Grafana](https://grafana.com/go/webinar/how-to-instrument-apps-with-otel-and-grafana-apac/) — Grafana Labs, 2026. Current instrumentation and signal visualization overview; hosted-product portions are optional for this local module.

Videos reinforce mental models; current primary documentation and the tested
repository baseline remain authoritative for configuration and behavior.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
