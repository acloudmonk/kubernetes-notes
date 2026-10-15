# Independent Challenge — Reliable Reservation

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Lab 2 — CloudCart delivery](labs/02-cloudcart-delivery.md) · Next:
> [Troubleshooting](troubleshooting.md)

Add an inventory-low workflow without copying the notification implementation.

## Constraints

- Inventory remains the sole owner of stock.
- A reservation and its event record are atomic.
- Delivery is at least once; duplicate effects are forbidden.
- Event evolution is backward compatible.
- Retries are bounded and terminal failures are inspectable.
- No secrets, generated state, or local environment files enter Git.

## Acceptance criteria

- An ADR explains whether this is a module or separate process and why.
- Tests prove the threshold boundary, concurrent reservations, duplicate event,
  malformed event, and unavailable broker behavior.
- A migration supports both old and new application versions during rollout.
- Logs correlate reservation and event IDs.
- A runbook detects backlog, restores delivery, and performs controlled replay.
- Cleanup returns the machine to its starting state.

## Cumulative review

Build the image using Module 02 practices, then explain the Linux process,
network sockets, read-only filesystem, signal path, and resource limits using
Module 01 concepts. This is evidence that the earlier modules transfer to a
distributed application.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Lab 2 — CloudCart delivery](labs/02-cloudcart-delivery.md) · Next:
> [Troubleshooting](troubleshooting.md)
