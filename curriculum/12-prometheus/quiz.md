# Knowledge Check

> **Module:** [12 — Prometheus](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

Answer every question before reading the answer section.

1. What uniquely identifies a Prometheus time series?
2. Which metric type should only increase until process restart?
3. Why should route templates replace raw URLs in labels?
4. Does `up == 1` prove users can complete an order?
5. Should you normally compute `rate(sum(counter)[5m])`?
6. Which label must remain when aggregating classic histogram buckets for a quantile?
7. What is the difference between target and metric relabeling?
8. What happens to `up` when a target is no longer discovered?
9. Does a recording rule reduce ingestion/storage cost?
10. What does an alert's `for` duration do?
11. Who groups and routes notifications: Prometheus or Alertmanager?
12. Does remote write remove the need to monitor local WAL queues and disk?

---

## Answers

1. Metric name plus the full label set.
2. Counter.
3. Raw URLs often contain unbounded IDs, creating series explosion and leaks.
4. No; it proves only the latest metrics scrape succeeded.
5. No; apply `rate` per counter series before summing so resets are handled.
6. `le`.
7. Target relabeling shapes/discards discovered targets before scraping; metric relabeling shapes/discards scraped samples before ingestion.
8. Its series becomes stale/disappears; it does not remain as zero indefinitely.
9. No. It reduces repeated query work but continuously creates stored series.
10. The expression must remain true continuously for that duration before firing.
11. Alertmanager.
12. No. Remote-write backpressure and local durability remain operational concerns.

> **Module:** [12 — Prometheus](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
