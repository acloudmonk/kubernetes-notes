# Lab 2 — DNS, HTTP, and TLS

**Time:** 45–60 minutes  
**Cost:** None  
**Requires:** Internet access for the TLS section

## Objective

Separate name resolution, TCP, TLS, and HTTP evidence.

## Tasks

```powershell
Resolve-DnsName example.com
Test-NetConnection example.com -Port 443
curl.exe -v https://example.com/
```

Record the resolved addresses, TCP result, certificate hostname, negotiated
protocol, HTTP status, and response server information. On Linux/WSL, repeat
with `getent` or `dig`, `curl -v`, and optionally `openssl s_client`.

## Controlled failure

Test these separately and classify the failing boundary:

```powershell
Resolve-DnsName name-that-should-not-exist.invalid
Test-NetConnection example.com -Port 81
curl.exe -v https://wrong.host.badssl.com/
```

The last endpoint is intentionally invalid for hostname verification; do not
disable certificate verification as the “fix.” Network policy may block some
tests, which is itself evidence to record.

## Cleanup

No persistent resource is created.
