# CloudCart Graduation Review

This page is the final handoff after Module 16. Graduation means the learner can
adapt the system under changed conditions—not that CloudCart is production-ready.

## Required evidence

- scored [Production Readiness gate](../curriculum/ASSESSMENT-GATES.md#gate-5--production-readiness);
- linked architecture, requirements, ownership, ADRs, risks, SLOs, and runbooks;
- reproducible application, container, Kubernetes, Helm, IaC, and GitOps paths;
- supply-chain, identity, policy, observability, capacity, cost, upgrade,
  disruption, backup, restoration, incident, and postmortem evidence;
- declared limitations, untested assumptions, and accepted risks; and
- a prioritized 30/60/90-day plan with owners and verification.

Never copy credentials, state, kubeconfigs, keys, production data, or private
diagnostic bundles into the evidence packet. Link sanitized summaries and
versioned configuration.

## Final review questions

1. Which failure can still violate the SLO and why?
2. Which component has the broadest privilege or blast radius?
3. What is the most uncertain recovery dependency?
4. Which recurring cost lacks a clear owner or value signal?
5. Which advanced component could be removed for a simpler system?
6. What changed because of the latest incident or game day?

Reassess a weak dimension with a changed scenario. Completion is a baseline for
continued practice, not an endpoint for Kubernetes learning.
