# Interview Questions

> **Module:** [12 — Prometheus](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

1. Trace a metric from code to a notification. Who owns each boundary?
2. Why does Prometheus pull, and when is Pushgateway appropriate?
3. What defines a time series, and how do you estimate cardinality?
4. Counter, gauge, histogram, or summary: how do you choose?
5. Why are user IDs, request IDs, and raw paths dangerous labels?
6. How do classic histogram quantiles work, and what errors do buckets introduce?
7. Explain instant vectors, range vectors, query range, and evaluation step.
8. Why should `rate` usually happen before aggregation?
9. How do you construct a mathematically correct error ratio?
10. What is vector matching, and when are `group_left` or `group_right` risky?
11. Compare `up == 0`, `absent(up)`, exporter failure, and stale series.
12. Explain service discovery, target relabeling, and metric relabeling.
13. What does a successful scrape prove—and not prove?
14. When should a recording rule exist? What does it cost?
15. Describe inactive, pending, firing, silenced, inhibited, and resolved alerts.
16. What belongs in alert labels versus annotations?
17. How do grouping, deduplication, inhibition, and routing interact?
18. Why can a firing Prometheus alert still produce no page?
19. How would you unit-test metrics, PromQL, rules, and notification routing?
20. How does local Prometheus storage work and fail?
21. What does two-replica Prometheus HA require from Alertmanager and queries?
22. Compare federation, remote write, and long-term compatible backends.
23. How do you detect and contain a cardinality incident?
24. What changes when Prometheus Operator owns configuration?
25. Design monitoring for the monitoring system without circular blind spots.

> **Module:** [12 — Prometheus](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
