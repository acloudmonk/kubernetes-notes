# Quick Exercises

> **Module:** [12 — Prometheus](README.md) · Previous: [Rules, Alertmanager, storage, and scale](04-alerting-storage-scale.md) · Next: [Lab 1 — Instrument, discover, and query](labs/01-instrument-discover-query.md)

1. Draw metric endpoint → discovery → relabel → scrape → TSDB → PromQL → rule
   → Alertmanager → receiver. Mark independent failure states.
2. Classify request total, queue depth, temperature, duration, build info, and
   last-success time as counter, gauge, histogram, or info-style metric.
3. Estimate series for ten buckets × six routes × five statuses × three methods
   × twenty replicas. Add one order-ID label and explain the new bound.
4. Explain why `sum(rate(counter[5m]))` handles resets better than
   `rate(sum(counter)[5m])`.
5. Write request rate, 5xx ratio, average latency, p95, and “99% under 250 ms.”
6. Predict `up == 0` versus `absent(up)` when a Pod is unready, deleted, or no
   longer selected by discovery.
7. Trace every EndpointSlice meta-label used by the lab relabel configuration.
8. Design alert labels that remain stable and annotations that help diagnosis.
9. Explain pending, firing, silenced, inhibited, grouped, and resolved states.
10. Compare two standalone replicas, federation, remote write, and a long-term
    compatible backend for availability, retention, and global query needs.

> **Module:** [12 — Prometheus](README.md) · Previous: [Rules, Alertmanager, storage, and scale](04-alerting-storage-scale.md) · Next: [Lab 1 — Instrument, discover, and query](labs/01-instrument-discover-query.md)
