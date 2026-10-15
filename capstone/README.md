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

See [`architecture/README.md`](architecture/README.md) for the current design.

## Boundaries

- No real payment processing or customer personal data
- No committed credentials
- No required cloud dependency where local work teaches the same objective
- No service split without an explicit reason and ownership boundary
