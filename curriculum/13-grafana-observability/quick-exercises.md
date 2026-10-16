# Quick Exercises

> **Module:** [13 — Grafana and observability](README.md) · Previous: [SLIs, SLOs, alerting, and operations](04-slos-alerting-operations.md) · Next: [Lab 1 — Deploy and explore](labs/01-deploy-explore.md)

1. Draw CloudCart's metric, log, and trace paths. Mark every queue, network hop,
   storage boundary, and place data can be dropped.
2. Classify `service.name`, route template, order ID, status class, trace ID,
   customer email, and Pod name as metric label, log field, span attribute,
   resource attribute, or prohibited data. Justify each answer.
3. Design an executive SLO view, service-owner RED view, and responder view.
   Give every panel a question and action.
4. Rewrite a Loki stream label set containing `trace_id`, raw URL, order ID, and
   exception message into a bounded set.
5. Write LogQL for CloudCart warnings and a count by level over five minutes.
6. Write TraceQL for CloudCart error spans and requests slower than 250 ms.
7. Explain when head sampling misses a valuable trace and what tail sampling
   costs in memory, routing, and delay.
8. Calculate the allowed bad requests for 99.5% availability at 2,000,000
   requests per 30 days. Then calculate burn rate at a 2% observed error ratio.
9. Explain why a p95 below 250 ms is not identical to “99% below 250 ms.”
10. Given a nonempty Prometheus query and empty panel, list the next five checks.
11. Given a trace with no log link, test ID format, time range, resource mapping,
    sampling, ingestion, and derived-field configuration in order.
12. Write production replacements for every deliberate lab shortcut.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [SLIs, SLOs, alerting, and operations](04-slos-alerting-operations.md) · Next: [Lab 1 — Deploy and explore](labs/01-deploy-explore.md)
