[CmdletBinding()]
param([string]$ClusterName = 'cloudcart-advanced')

$ErrorActionPreference = 'Stop'
if ((kubectl config current-context) -ne "kind-$ClusterName") { throw 'Unexpected Kubernetes context.' }
$request = 'import urllib.request; response=urllib.request.urlopen("http://mesh-server:8080",timeout=5); print(response.status)'

$authorized = kubectl exec -n mesh-lab deploy/mesh-client -- python -c $request
if ($LASTEXITCODE -ne 0 -or $authorized -notcontains '200') { throw 'Authorized mesh identity could not reach the server.' }

kubectl exec -n mesh-lab deploy/mesh-other -- python -c $request *> $null
if ($LASTEXITCODE -eq 0) { throw 'Unauthorized mesh identity unexpectedly reached the server.' }

$workloads = istioctl ztunnel-config workloads --workload-namespace mesh-lab
if ($LASTEXITCODE -ne 0 -or ($workloads -join "`n") -notmatch 'mesh-server' -or ($workloads -join "`n") -notmatch 'HBONE') {
    throw 'ztunnel does not report the enrolled mesh workloads over HBONE.'
}
$policy = kubectl get authorizationpolicy mesh-server-client-only -n mesh-lab -o json | ConvertFrom-Json
if ($policy.spec.rules[0].from[0].source.principals[0] -ne 'cluster.local/ns/mesh-lab/sa/mesh-client') {
    throw 'Authorization policy identity is not the expected ServiceAccount.'
}
Write-Output 'Mesh test=PASS transport=ambient-mTLS authorized=mesh-client denied=mesh-other policy=identity'
