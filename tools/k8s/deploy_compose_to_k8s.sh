#!/usr/bin/env bash
set -euo pipefail

compose_file="${1:-docker-compose.app.yml}"

cluster_name="${K3D_CLUSTER_NAME:-fc-dev}"
namespace="${NAMESPACE:-debug-app}"
service_name="${SERVICE_NAME:-debug-app}"

app_image="${APP_IMAGE:-firecracker-k8s-debug-app:dev}"
build_image="${BUILD_IMAGE:-1}"

require_bin() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: missing required command: $1" >&2
    exit 1
  fi
}

require_bin kubectl
require_bin kompose

if [[ "$build_image" = "1" && "$compose_file" = "docker-compose.app.yml" ]]; then
  require_bin docker
  require_bin k3d

  docker build -t "$app_image" tools/k8s/sample-app
  k3d image import -c "$cluster_name" "$app_image"
fi

tmp_dir="$(mktemp -d)"
cleanup() { rm -rf "$tmp_dir"; }
trap cleanup EXIT

kubectl get namespace "$namespace" >/dev/null 2>&1 || kubectl create namespace "$namespace" >/dev/null

kompose convert -f "$compose_file" -o "$tmp_dir"
kubectl -n "$namespace" apply -f "$tmp_dir"

kubectl -n "$namespace" rollout status "deployment/${service_name}" --timeout=180s

echo "Deployed ${service_name} into namespace ${namespace}."
echo "HTTP:   kubectl -n ${namespace} port-forward svc/${service_name} 3000:3000"
echo "Debug:  kubectl -n ${namespace} port-forward svc/${service_name} 9229:9229"
