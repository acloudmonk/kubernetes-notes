# Lab 3 — Configuration and Dependency Failure

**Time:** 45–60 minutes  
**Cost:** None  
**Requires:** Python

## Objective

Trace a dependency failure caused by incorrect configuration.

## Tasks

Start a dependency:

```powershell
python -m http.server 8090 --bind 127.0.0.1
```

In a second PowerShell window:

```powershell
$env:DEPENDENCY_URL = 'http://127.0.0.1:8090/'
python curriculum/00-prerequisites/scripts/dependency_probe.py
```

Then introduce one error at a time:

```powershell
$env:DEPENDENCY_URL = 'http://name-that-should-not-exist.invalid:8090/'
python curriculum/00-prerequisites/scripts/dependency_probe.py
$env:DEPENDENCY_URL = 'http://127.0.0.1:8091/'
python curriculum/00-prerequisites/scripts/dependency_probe.py
```

For each result, identify configuration, DNS, connection, timeout, or HTTP as
the failing boundary. Explain why a blind retry cannot fix a wrong hostname.

## Cleanup

Stop the HTTP server and remove the session variable:

```powershell
Remove-Item Env:DEPENDENCY_URL
```
