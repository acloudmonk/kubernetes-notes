# Interview Questions

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

1. How do monitoring and observability differ in practice?
2. When would you choose a metric, log, trace, or profile?
3. What are OpenTelemetry API, SDK, OTLP, semantic conventions, and Collector?
4. Why send telemetry through a Collector instead of directly to each backend?
5. Compare Collector agent and gateway topologies.
6. What happens when an exporter backend applies backpressure?
7. Which fields belong in resource attributes versus span attributes?
8. How do you prevent credentials and personal data entering telemetry?
9. Why is a trace ID a bad Prometheus or Loki stream label?
10. How does Loki's indexing model differ from full-text log indexing?
11. What makes a dashboard operationally useful rather than decorative?
12. How do you manage Grafana dashboards and data sources as code?
13. Explain trace context propagation across HTTP and a message broker.
14. Compare automatic and manual instrumentation.
15. Compare head sampling, tail sampling, and adaptive sampling.
16. Why does absence of a trace not prove absence of a request?
17. What is a Prometheus exemplar, and what does it not guarantee?
18. How do metric-to-trace, trace-to-log, and log-to-trace links work?
19. Define SLI, SLO, SLA, error budget, and burn rate.
20. Why is “p95 under 250 ms” different from “99% under 250 ms”?
21. Explain a multi-window, multi-burn-rate alert.
22. Which 4xx responses should count against availability?
23. How would you monitor the observability pipeline itself?
24. What must change before the lab stack is production-ready?
25. Walk through diagnosing a slow CloudCart order without starting from logs.

Strong answers state assumptions, measurement points, failure modes, privacy and
cost limits, and concrete verification—not only product definitions.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
