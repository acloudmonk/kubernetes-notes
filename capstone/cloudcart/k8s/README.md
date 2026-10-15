# CloudCart Plain Kubernetes Manifests

These learning manifests are orchestrated by
[Module 05](../../../curriculum/05-kubernetes-workloads/README.md). They use
disposable `emptyDir` storage; deleting or replacing a dependency Pod deletes
its data. Persistent state, backup, and StatefulSets are intentionally deferred
to Module 07.

No Secret values are committed. On its first run, the module deployment script
generates random lab-only credentials directly in the `cloudcart` namespace;
reruns reuse that Secret so existing dependency processes remain consistent.
Do not commit rendered Secrets, kubeconfigs, or exported cluster diagnostics.

- `base/` creates the namespace, non-sensitive configuration, Services, and dependencies.
- `migration-job.yaml` performs the finite, idempotent schema migration.
- `applications.yaml` runs the API, outbox relay, and notification worker.
- `networking/` adds Gateway API routing and default-deny NetworkPolicies for Module 06.

The API has startup, readiness, and liveness probes. The relay and worker do
not expose a truthful health endpoint yet; process liveness alone would not
prove message progress. Module 13 will add operational telemetry.

CloudCart-owned containers drop all capabilities and run as a fixed non-root
UID. The upstream PostgreSQL and RabbitMQ images perform entrypoint ownership
and user transitions, so this learning baseline does not blindly apply the same
capability set to them. Harden third-party images only after testing their
documented startup requirements or selecting a compatible non-root image.

The networking layer allows only documented DNS, API, database, broker,
migration, test-client, and Gateway paths. Policy effectiveness still depends
on the cluster's network implementation.
