"""Minimal namespace-scoped controller used to expose Kubernetes API mechanics."""

import json
import os
import ssl
import time
import urllib.error
import urllib.request
from datetime import datetime, timezone

API = os.getenv("KUBERNETES_SERVICE_HOST", "kubernetes.default.svc")
PORT = os.getenv("KUBERNETES_SERVICE_PORT_HTTPS", "443")
NAMESPACE = os.getenv("WATCH_NAMESPACE", "operator-lab")
TOKEN_PATH = "/var/run/secrets/kubernetes.io/serviceaccount/token"
CA_PATH = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
FINALIZER = "learning.cloudcart.io/configmap-cleanup"
RESOURCE_PATH = f"/apis/learning.cloudcart.io/v1alpha1/namespaces/{NAMESPACE}/cloudcartpolicies"


def desired_configmap(resource):
    name = resource["metadata"]["name"]
    return {
        "apiVersion": "v1",
        "kind": "ConfigMap",
        "metadata": {
            "name": f"policy-{name}",
            "namespace": resource["metadata"]["namespace"],
            "labels": {"app.kubernetes.io/managed-by": "cloudcart-policy-controller"},
            "ownerReferences": [{
                "apiVersion": resource["apiVersion"],
                "kind": resource["kind"],
                "name": name,
                "uid": resource["metadata"]["uid"],
                "controller": True,
                "blockOwnerDeletion": True,
            }],
        },
        "data": {"message": resource["spec"]["message"]},
    }


def request(method, path, body=None, content_type="application/json"):
    token = open(TOKEN_PATH, encoding="utf-8").read().strip()
    payload = None if body is None else json.dumps(body).encode()
    req = urllib.request.Request(
        f"https://{API}:{PORT}{path}", data=payload, method=method,
        headers={"Authorization": f"Bearer {token}", "Content-Type": content_type},
    )
    context = ssl.create_default_context(cafile=CA_PATH)
    with urllib.request.urlopen(req, context=context, timeout=10) as response:
        data = response.read()
        return json.loads(data) if data else None


def ignore_not_found(method, path, body=None, content_type="application/json"):
    try:
        return request(method, path, body, content_type)
    except urllib.error.HTTPError as error:
        if error.code == 404:
            return None
        raise


def reconcile(resource):
    metadata = resource["metadata"]
    name = metadata["name"]
    item_path = f"{RESOURCE_PATH}/{name}"
    configmap_path = f"/api/v1/namespaces/{NAMESPACE}/configmaps/policy-{name}"
    finalizers = metadata.get("finalizers", [])

    if metadata.get("deletionTimestamp"):
        ignore_not_found("DELETE", configmap_path)
        if FINALIZER in finalizers:
            remaining = [value for value in finalizers if value != FINALIZER]
            request("PATCH", item_path, {"metadata": {"finalizers": remaining}}, "application/merge-patch+json")
        return

    if FINALIZER not in finalizers:
        request("PATCH", item_path, {"metadata": {"finalizers": finalizers + [FINALIZER]}}, "application/merge-patch+json")
        return

    desired = desired_configmap(resource)
    current = ignore_not_found("GET", configmap_path)
    if current is None:
        request("POST", f"/api/v1/namespaces/{NAMESPACE}/configmaps", desired)
    elif current.get("data") != desired["data"]:
        desired["metadata"]["resourceVersion"] = current["metadata"]["resourceVersion"]
        request("PUT", configmap_path, desired)

    status = resource.get("status", {})
    if status.get("observedGeneration") != metadata["generation"] or status.get("ready") is not True:
        now = datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")
        request("PATCH", f"{item_path}/status", {"status": {
            "observedGeneration": metadata["generation"],
            "ready": True,
            "configMap": f"policy-{name}",
            "conditions": [{"type": "Ready", "status": "True", "reason": "Reconciled", "lastTransitionTime": now}],
        }}, "application/merge-patch+json")


def run():
    while True:
        try:
            for resource in request("GET", RESOURCE_PATH).get("items", []):
                try:
                    reconcile(resource)
                except Exception as error:  # keep other objects reconciling
                    print(f"reconcile_error name={resource['metadata']['name']} error={error}", flush=True)
        except Exception as error:
            print(f"list_error error={error}", flush=True)
        time.sleep(2)


if __name__ == "__main__":
    run()
