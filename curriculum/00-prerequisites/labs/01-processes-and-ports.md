# Lab 1 — Processes and Ports

**Time:** 30–45 minutes  
**Cost:** None  
**Requires:** Python and either PowerShell or Linux/WSL tools

## Objective

Start a service, locate its process and socket, terminate it gracefully, and
diagnose a port conflict.

## Tasks

Start a local-only server:

```powershell
python -m http.server 8080 --bind 127.0.0.1
```

In another PowerShell window, collect evidence:

```powershell
Get-NetTCPConnection -LocalPort 8080 -State Listen
Get-Process -Id (Get-NetTCPConnection -LocalPort 8080 -State Listen).OwningProcess
curl.exe -i http://127.0.0.1:8080/
```

Linux/WSL equivalents are `ss -lntp`, `ps`, and `curl`. Stop the server with
Ctrl+C and prove the listener disappeared.

## Controlled failure

Start the server again, then attempt to start a second server on port 8080.
Explain the bind error using socket evidence, choose port 8081 for the second
process, and verify both listeners.

## Cleanup

Stop only the two Python servers you started. Verify that neither port remains
in the listening state.
