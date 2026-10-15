# Troubleshooting Scenario — Container Exits Immediately

A service container appears briefly and then disappears from `docker ps`.
Repeated `docker start` attempts produce the same result.

## Evidence to collect

```powershell
docker ps --all
docker inspect <container>
docker logs <container>
docker image inspect <image>
```

Ask:

1. What command and entrypoint were effective?
2. What were state, exit code, error, OOM flag, and timestamps?
3. Did PID 1 finish, fail to start, receive a signal, or exhaust a resource?
4. Was the workload intended to be a service or a finite job?

Stop and diagnose before reading further.

---

## Possible diagnoses

- Exit `0` with expected output: the finite command completed successfully.
- Nonzero exit with logs: the application rejected configuration or failed.
- Runtime error before logs: command, executable, mount, or permission problem.
- OOM evidence: memory constraint or workload usage requires investigation.
- Forced termination: inspect stop events, signals, and grace time.

Keeping a container alive with an unrelated infinite command hides rather than
fixes a service whose main process cannot remain healthy.
