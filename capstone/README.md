# CloudCart Capstone

CloudCart is an order-processing learning system. It exposes realistic design
and operational choices without becoming a product-sized application.

A customer browses a catalog and submits an order. The system reserves
inventory and emits an event that triggers a notification. Payment is only a
simulation; no real financial integration or credentials are used.

## Candidate capabilities

- Catalog with persistent product data
- Orders with persistent order data
- Inventory reservation
- Notification worker consuming asynchronous events
- Relational storage with explicit ownership
- A broker selected through an architecture decision record
- Optional caching only when a measurable use case exists

The first implementation is modular. Service decomposition occurs only after
boundaries and failure behavior are understood.

## Evolution

1. Architecture and domain baseline
2. Tested modular application
3. Docker images and Compose environment
4. Selected service decomposition and messaging
5. Plain Kubernetes manifests
6. Networking, persistence, security, resources, and scaling
7. Helm packaging
8. Metrics, logs, traces, dashboards, alerts, and SLOs
9. CI/CD and GitOps
10. Resilience, backup, recovery, and operational review

## Progressive test strategy

Tests are added with the capability they protect:

1. Unit and configuration tests
2. Database integration and migration tests
3. API and event contract tests
4. Container startup, health, shutdown, and security smoke tests
5. Kubernetes schema and policy validation
6. Helm render, install, upgrade, rollback, and chart tests
7. End-to-end and GitOps reconciliation tests
8. Load, disruption, chaos, backup, and restoration tests

Each test states what risk it detects and what failure it cannot detect.

See [`architecture/README.md`](architecture/README.md) for the current design.
The runnable Module 03 increment is in [`cloudcart`](cloudcart/README.md).

## Boundaries

- No real payment processing or customer personal data
- No committed credentials
- No required cloud dependency where local work teaches the same objective
- No service split without an explicit reason and ownership boundary
