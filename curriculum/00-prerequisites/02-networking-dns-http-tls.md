# Networking, DNS, HTTP, and TLS

## Address and port

An IP address identifies an interface; a port identifies a socket endpoint.
Binding to `127.0.0.1` accepts local traffic only. Binding to `0.0.0.0` listens
on all IPv4 interfaces but is not itself a destination address.

TCP establishes an ordered byte stream. A successful TCP connection proves a
listener and route exist; it does not prove the application protocol is healthy.

## DNS

DNS maps names to records such as A, AAAA, and CNAME. A resolver may consult
local overrides and caches before configured DNS servers. Separate these cases:

- Name cannot be resolved.
- Name resolves to an unexpected address.
- Address is correct but the port is unreachable.
- TCP works but HTTP or TLS fails.

```powershell
Resolve-DnsName example.com
Test-NetConnection example.com -Port 443
```

```bash
getent hosts example.com
dig example.com
curl -v https://example.com/
```

## HTTP

HTTP consists of a method, target, headers, and optional body followed by a
status response. Status families are signals, not complete diagnoses: 4xx
usually concerns the request or authorization; 5xx means a server or upstream
failed to satisfy it. Always inspect the response and server logs together.

## TLS

TLS authenticates a peer with certificates and protects data in transit. A
client validates the chain, validity period, and requested hostname. Common
failures include wrong system time, missing trust roots, expired certificates,
and a hostname absent from the certificate SAN entries.

```bash
openssl s_client -connect example.com:443 -servername example.com
```

## Diagnostic order

Configuration → name resolution → route → TCP connection → TLS negotiation →
HTTP response → application dependency. Test one boundary at a time.
