# Knowledge Check

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

Answer every question before reading the answer section.

1. Does installing Grafana make a system observable?
2. Which component creates a CloudCart server span?
3. Which component stores CloudCart traces in the lab?
4. Why is `trace_id` present in log content but not a Loki stream label?
5. Does a missing trace prove the request did not happen?
6. What is the difference between a resource attribute and span attribute?
7. Why does the Collector run as a DaemonSet in this lab?
8. What does a Prometheus exemplar provide?
9. Why must Grafana's Tempo and Loki data sources both be configured for
   bidirectional trace/log navigation?
10. For a 99.5% SLO, what is the error-budget fraction?
11. What does a burn rate of 10 mean?
12. Why combine short and long windows in a burn-rate alert?
13. Is anonymous Viewer access a production recommendation?
14. Which lab storage survives Pod replacement?
15. What should you query before concluding an empty Grafana panel means no data?

---

## Answers

1. No. It visualizes/query data; instrumentation, pipelines, backends, context,
   and operational practice provide observability.
2. CloudCart's OpenTelemetry HTTP middleware.
3. Tempo.
4. A trace ID is high cardinality; indexing it would create a stream per trace.
5. No. The request may be unsampled, unexported, expired, or dropped.
6. A resource describes the producing entity; a span attribute describes one
   operation.
7. It must read each node's local Kubernetes container log files.
8. A representative observation linked to trace context, not every observation.
9. Tempo needs trace-to-log mapping and Loki needs a derived trace link.
10. 0.005, or 0.5%.
11. The budget is being consumed ten times as fast as sustainable over the full
    objective window.
12. The short window detects quickly; the long window reduces transient noise.
13. No. It is a local, ClusterIP-only teaching shortcut.
14. None of the Grafana/Loki/Tempo/Prometheus lab `emptyDir` data.
15. The underlying backend API with the same query and time range.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
