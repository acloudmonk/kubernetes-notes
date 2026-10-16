# Lab 1 — Build and Verify Supply-Chain Evidence

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2](02-reconcile-drift-recover.md)

## Outcome and safety

Build CloudCart once and bind an SBOM, scan result, Helm checksum, disposable
signature, and source revision into ignored `tmp/module14/evidence`. The lab uses
no registry or production credentials. Its generated private key is deleted even
on failure; delete the whole output directory during cleanup.

## Prerequisites

Docker Linux engine, Helm 4.3.1, Syft 1.54.1, Grype 0.120.1, Cosign 3.0.5,
PowerShell 7, and network access for vulnerability database updates. Verify each
binary from its official release checksum/signature before use.

## Run and inspect

```powershell
./curriculum/14-cicd-supply-chain-gitops/scripts/Test-SupplyChain.ps1
Get-Content tmp/module14/evidence/provenance-summary.json
```

Inspect the CycloneDX metadata and component count, Grype database/status and
matches, image ID, chart SHA-256, public key, and Sigstore bundle. Explain why
the locally generated key proves mechanics but is not a production trust root.

## Controlled failures

Change one byte in a copied chart package and confirm `cosign verify-blob` fails.
Run a scan with a deliberately strict threshold and treat the nonzero result as
policy evidence, not tool failure. Restore by regenerating the exact artifact;
never suppress a failing exit code.

## Cleanup

```powershell
Remove-Item -Recurse -Force tmp/module14
```

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2](02-reconcile-drift-recover.md)
