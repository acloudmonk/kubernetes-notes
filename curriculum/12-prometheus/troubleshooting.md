# Troubleshooting Prometheus

> **Module:** [12 — Prometheus](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

## Evidence order

1. State the expected target, series, query result, alert instance, and receiver.
2. Check Prometheus process readiness, logs, configuration, rule health, disk, and time.
3. Inspect discovery candidates, dropped targets, relabel results, and target errors.
4. Fetch the metrics endpoint from Prometheus's network and inspect exposition.
5. Query the raw series before rates, aggregation, joins, or recording rules.
6. Inspect rule evaluation, pending/firing labels, and Alertmanager delivery errors.
7. Inspect Alertmanager route matching, grouping, inhibition, silences, and receiver response.

## Failure map

| Symptom | Boundary | Evidence | Direction |
|---|---|---|---|
| target absent | discovery/relabel/RBAC | service discovery page, EndpointSlice, dropped targets | repair selectors, annotations, namespace scope, or keep/drop regex |
| `up == 0` | scrape/network/endpoint | target last error, DNS/TLS/auth/path, endpoint response | reproduce from Prometheus network; fix transport or exporter |
| endpoint works but metric absent | exposition/relabel/staleness | raw text, metric relabel, scrape sample counts | fix name/type or sample filtering |
| rate empty/spiky | query/window/reset | raw counter and scrape timestamps | use a sufficient window and rate before sum |
| ratio wrong | label mismatch/math | numerator/denominator labels and zero traffic | align dimensions and guard denominator |
| quantile implausible | buckets/traffic/query | bucket boundaries/count and aggregation by `le` | redesign buckets or correct aggregation |
| alert pending forever | rule timing/flapping | expression over time, `for`, evaluation interval | stabilize signal; do not merely shorten `for` |
| firing only in Prometheus | delivery | Prometheus notifier metrics/logs, Alertmanager target | repair reachability/config and HA fan-out |
| in Alertmanager, no page | routing/receiver | route tree, silence/inhibition, notification metrics | test matcher, grouping, credential, provider response |
| memory/disk growth | cardinality/churn/retention | TSDB status, top labels, WAL/blocks, scrape samples | stop source, drop safely, reduce scope, then size storage |
| query overload | query shape/concurrency | engine metrics, query log/stats, samples | narrow matchers/windows, record, limit, or shard |

Never delete TSDB data or silence alerts before preserving evidence and verifying
scope. Cardinality incidents require stopping new series creation first; restart
alone does not repair the metric contract.

> **Module:** [12 — Prometheus](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
