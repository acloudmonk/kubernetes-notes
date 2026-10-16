# Independent Challenge

> **Module:** [12 — Prometheus](README.md) · Previous: [Lab 2 — Fire, route, and recover](labs/02-alert-route-recover.md) · Next: [Troubleshooting](troubleshooting.md)

Instrument and monitor another service without copying CloudCart names or rules.
Begin with three user questions and a series budget, then implement only metrics
that answer them.

## Required evidence

- metric contract covering type, unit, HELP, label bounds, lifecycle, and owner;
- RED application metrics plus one justified business or dependency metric;
- Kubernetes discovery and relabel proof from candidate to active target;
- correct rates, ratio, histogram quantile, exact bucket objective, and absence query;
- one budgeted recording rule and two actionable alerts with unit tests;
- Alertmanager grouping, route, silence, inhibition, and resolved-flow evidence;
- measured head series, scrape samples, ingestion/storage estimate, and top risk;
- monitoring health, retention, backup/recovery, HA, and long-term-scale design;
- two injected failures: one discovery/scrape and one rule/routing failure;
- evidence that no identifier, credential, personal data, or raw error appears in labels.

## Review standard

Another operator must be able to distinguish “service failed,” “monitoring
failed,” and “notification failed,” reproduce every query, and understand what
the metrics cannot prove. A larger dashboard is not a substitute for correctness.

> **Module:** [12 — Prometheus](README.md) · Previous: [Lab 2 — Fire, route, and recover](labs/02-alert-route-recover.md) · Next: [Troubleshooting](troubleshooting.md)
