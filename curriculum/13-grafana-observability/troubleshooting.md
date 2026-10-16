# Troubleshooting

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

## Evidence order

Confirm context and workload state before changing configuration:

```powershell
kubectl config current-context
kubectl get pods -n monitoring -o wide
kubectl get events -n monitoring --sort-by=.lastTimestamp
kubectl get endpointslice -n monitoring
```

## Deployment failures

| Symptom | Evidence | Likely direction |
|---|---|---|
| Image pull error | Pod events, exact image ID | network, tag/digest, platform |
| Loki not ready | Loki logs and `/ready` | config, permissions, storage |
| Tempo crash loop | Tempo logs, mounted config | strict YAML, paths, ownership |
| Collector not ready | Collector logs, config validation | unsupported component/config |
| Grafana not ready | Grafana logs, `/api/health` | provisioning, mount, write path |
| Pending Pods | scheduler events, node allocation | local CPU/memory pressure |

The images are multi-platform digest pins. Do not replace them with `latest` to
hide an error. Compare node architecture and manifest-list platforms.

## Empty Grafana panel

1. Inspect the panel query, time range, variables, data-source UID, and interval.
2. Open data-source **Save & test** (read-only provisioning still permits Test).
3. issue the same query in Explore;
4. query Prometheus/Loki/Tempo directly from the client Pod;
5. inspect backend logs and the Collector exporter path;
6. confirm timestamps and resource/label names.

An empty result can be correct. Distinguish no events from ingestion failure and
from a query that excludes valid data.

## Logs missing from Loki

Inspect API stdout first. Then check the Pod's node and the Collector Pod on that
node. The DaemonSet mounts `/var/log/pods`; its filelog include is intentionally
limited to CloudCart API Pods. Check file permissions, glob matching, receiver
accepted/refused counters, exporter retries, Loki readiness, and the exact
`service_name` label. Container log rotation can create duplicates or gaps if
file fingerprints and storage are not durable.

## Traces missing from Tempo

Confirm the CloudCart Deployment has `OTEL_EXPORTER_OTLP_ENDPOINT`, the API Pods
rolled after it was set, collector Service endpoints exist, and the Collector
trace exporter is not retrying. Query Tempo directly. Check sampling before
assuming loss. The SDK exports batches asynchronously, so allow a bounded delay.

## Correlation link fails

- Ensure the log line contains a 32-character lowercase `trace_id`.
- Verify the Loki derived-field regex and Tempo UID.
- Verify Tempo `tracesToLogsV2` maps `service.name` to `service_name`.
- Expand a narrowly bounded time range for clock/export delay.
- Confirm that exact trace ID exists in Tempo.
- For exemplars, verify OpenMetrics exposition and Prometheus
  `--enable-feature=exemplar-storage`.

## SLI has no data or misleading data

Check source counters before recording rules, rule health, traffic volume, rate
window, zero-denominator handling, status-code population, and whether timed-out
requests ever completed. `clamp_min` prevents division errors but can mask a
low-traffic denominator; explicitly visualize traffic alongside the ratio.

## Local resource pressure

Use `kubectl top` only after confirming Metrics Server is available; otherwise
inspect requests, limits, node allocatable values, events, restarts, and
`OOMKilled`. Stop other clusters or increase Docker Desktop resources. Do not
remove limits blindly—the lab is designed to teach bounded capacity.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
