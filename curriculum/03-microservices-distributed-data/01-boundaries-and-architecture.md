# Boundaries and Architecture

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Module overview](README.md) · Next:
> [Synchronous contracts and resilience](02-synchronous-contracts-resilience.md)

## Architecture is a set of tradeoffs

A microservice is independently deployable software aligned to a business
capability and owned with its data and operational behavior. File count,
framework, repository layout, or container count does not create that property.
A service boundary is useful when it reduces coordination cost more than it
adds network, data, delivery, and operational cost.

Start with a modular monolith when the domain or team boundaries are still
changing. Enforce modules through public interfaces and ownership rules. Split
a module only when evidence supports independent change, scaling, reliability,
security, or team autonomy. A distributed monolith has separate processes but
still requires coordinated releases, shared writes, or synchronous availability;
it pays distribution costs without gaining autonomy.

## Find boundaries

Model business capabilities and their invariants:

- **Catalog** owns product descriptions and prices.
- **Inventory** owns available stock and the rule that stock cannot be negative.
- **Ordering** owns order lifecycle and request idempotency.
- **Notification** owns notification attempts, not order truth.

An aggregate is the consistency boundary inside which invariants must hold in
one transaction. Cross-aggregate and cross-service workflows need explicit
coordination. Do not let convenience queries turn into unowned cross-schema
writes.

Ask for every proposed boundary:

1. What business decision and data does it own?
2. Can it change and deploy without coordinated releases?
3. What happens when it or a dependency is unavailable?
4. Who operates it, and which SLO and alerts do they own?
5. Is the added complexity justified now?

## Coupling

Coupling is not eliminated; it changes form. Temporal coupling requires two
components to be available together. Contract coupling requires agreement on a
schema. Data coupling exposes storage details. Deployment coupling forces a
coordinated release. Prefer stable contracts and minimize the number of reasons
two components must change together.

## CloudCart decision

CloudCart keeps Catalog, Inventory, and Ordering in one API process for now.
PostgreSQL schemas make ownership visible, and code crosses capability
boundaries through an application service. Notification is asynchronous because
it should not extend order latency or determine order success. The split teaches
a justified boundary while retaining a transaction for the stock invariant.

## Review prompts

- Why is “one database per service” about ownership rather than one server?
- Which evidence would justify extracting Inventory from CloudCart?
- Identify a change that would expose a distributed monolith.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Module overview](README.md) · Next:
> [Synchronous contracts and resilience](02-synchronous-contracts-resilience.md)
