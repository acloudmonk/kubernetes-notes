# References and Videos

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

Written sources are authoritative for current behavior. Videos build intuition
but may show older library versions or operational defaults.

## Architecture and reliability

- [Microservices guide — Martin Fowler](https://martinfowler.com/microservices/)
- [Microservices — James Lewis and Martin Fowler](https://martinfowler.com/articles/microservices.html)
- [Timeouts, retries, and backoff with jitter — Amazon Builders' Library](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
- [Control and limit retry calls — AWS Well-Architected](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/rel_mitigate_interaction_failure_limit_retries.html)
- [Idempotent requests — Stripe API](https://docs.stripe.com/api/idempotent_requests)

## Data and messaging patterns

- [Transactional outbox — Chris Richardson](https://microservices.io/patterns/data/transactional-outbox.html)
- [Saga — Chris Richardson](https://microservices.io/patterns/data/saga.html)
- [RabbitMQ tutorials](https://www.rabbitmq.com/tutorials)
- [Consumer acknowledgements and publisher confirms](https://www.rabbitmq.com/docs/confirms)
- [Dead lettering](https://www.rabbitmq.com/docs/dlx)
- [PostgreSQL transaction isolation](https://www.postgresql.org/docs/current/transaction-iso.html)

## Implementation

- [FastAPI testing](https://fastapi.tiangolo.com/tutorial/testing/)
- [FastAPI containers](https://fastapi.tiangolo.com/deployment/docker/)
- [Psycopg transactions](https://www.psycopg.org/psycopg3/docs/basic/transactions.html)
- [Pika documentation](https://pika.readthedocs.io/)

## Videos

- [Microservices — Martin Fowler, GOTO Conferences (2014)](https://www.youtube.com/watch?v=wgdBVIX9ifA):
  use for the architectural characteristics, prerequisites, and tradeoffs. It is
  deliberately foundational and old; verify tooling and platform advice against
  current written documentation.
- [Not Just Events: Developing Asynchronous Microservices — Chris Richardson,
  GOTO Conferences (2019)](https://www.youtube.com/watch?v=kyNL7yCvQQc): use for
  Saga, CQRS, and asynchronous data-management reasoning. The patterns remain
  useful, but library examples and product versions may be dated.

## Freshness check

Before running the lab, compare dependency and image pins with upstream release
and support information. Update intentionally in a dedicated change, execute all
tests and failure exercises, and record the new baseline; do not silently use
floating tags.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
