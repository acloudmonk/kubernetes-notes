# CloudCart Ownership and Failure Model

## Capability ownership

| Capability | Owns | Invariant | Other capabilities may |
|---|---|---|---|
| Catalog | Product identity, description, price | SKU is unique; price is non-negative | Read through the catalog contract |
| Inventory | Available stock | Available stock never becomes negative | Request a reservation |
| Ordering | Orders, lines, request idempotency | One logical command creates at most one order | Query an order through its contract |
| Messaging | Publication intent and relay state | Every committed event remains publishable | Observe backlog; never rewrite payload ad hoc |
| Notification | Processed notification events | One event ID has at most one local effect | Request notification through an event |

Schemas share one PostgreSQL instance for the learning increment, but ownership
is logical: code outside an owner must not write its tables. A future service
split may move a schema without changing who owns it.

## Failure behavior

| Failure | Order outcome | Evidence | Recovery |
|---|---|---|---|
| Database unavailable before commit | No confirmed order | API error and no order/key | Retry with the same key after recovery |
| Client timeout after commit | Unknown to client; order exists | Same key returns saved order | Query/retry idempotently |
| Broker unavailable | Order and outbox commit | Unpublished count/age grows | Restore broker; relay drains backlog |
| Relay crashes after publish | Possible duplicate | Same event ID redelivered | Consumer deduplicates |
| Worker crashes before commit | No notification effect | Message redelivered | Process again |
| Worker crashes after commit, before ack | Effect exists; duplicate delivery | Processed event ID exists | Consumer ignores duplicate and acknowledges |
| Malformed message | No effect | DLQ entry and error log | Fix cause; controlled replay |

## Extraction criteria

Extract a capability only after its API/event contract and ownership are stable
and evidence shows independent deployability, scale, reliability, security, or
team autonomy is valuable. The extraction must include data migration,
coexistence, rollback, observability, and operator ownership.
