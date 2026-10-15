# Threat Model

The threat model evolves with every deployment stage.

## Assets

- Order and inventory integrity
- User and service identities
- Credentials and signing material
- Availability and deployment provenance
- Telemetry that may reveal request or system details

## Initial trust boundaries

- User to application entry point
- Entry point to internal capability
- Service to persistent storage
- Producer to broker to consumer
- CI system to registry and deployment environment
- Cluster workload to Kubernetes API

For each stage, identify assets and entry points, draw identity and data flows,
enumerate spoofing, tampering, disclosure, denial-of-service, and privilege
escalation risks, record mitigations and residual risks, and add verification
exercises where practical.

This is a framework, not a claim that future implementations are already safe.
