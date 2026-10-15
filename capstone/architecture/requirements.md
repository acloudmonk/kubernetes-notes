# Capstone Requirements

## Functional baseline

1. A user can list catalog items.
2. A user can submit an order containing one or more items.
3. The system validates and reserves inventory.
4. A successful order produces a notification request.
5. Order status can be retrieved.
6. Duplicate requests or messages do not duplicate business effects.

## Quality baseline

- Components support graceful startup and shutdown.
- Workloads expose appropriate readiness and health behavior.
- Structured logs correlate work across boundaries.
- Metrics support rate, error, duration, and saturation analysis.
- Dependencies use explicit timeouts.
- Credentials enter through an external configuration mechanism.
- Deployment supports safe rollout and rollback.
- Persistent data has documented backup and recovery.

## Deferred decisions

Language, broker, local Kubernetes distribution, routing implementation, and
GitOps controller will be selected through ADRs when necessary. Decisions must
consider learning value, maintainability, support, and operational cost.

## Out of scope

- Real payment processing
- Production handling of personal information
- A feature-complete storefront
- Premature multi-region or multi-cluster implementation
