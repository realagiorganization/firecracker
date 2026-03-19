#!/usr/bin/env bash
set -euo pipefail

cluster_name="${K3D_CLUSTER_NAME:-fc-dev}"
servers="${K3D_SERVERS:-1}"
agents="${K3D_AGENTS:-1}"
k3s_image="${K3D_K3S_IMAGE:-rancher/k3s:v1.30.6-k3s1}"
port_http="${K3D_PORT_HTTP:-8080:80@loadbalancer}"

if ! docker version >/dev/null 2>&1; then
  echo "ERROR: Docker is not reachable. Ensure /var/run/docker.sock is mounted." >&2
  exit 1
fi

if ! k3d kubeconfig get "$cluster_name" >/dev/null 2>&1; then
  echo "Creating k3d cluster: ${cluster_name}"
  k3d cluster create "$cluster_name" \
    --image "$k3s_image" \
    --servers "$servers" \
    --agents "$agents" \
    --port "$port_http" \
    --wait
fi

kube_dir="${HOME:-/root}/.kube"
mkdir -p "$kube_dir"
k3d kubeconfig get "$cluster_name" >"$kube_dir/config"
export KUBECONFIG="$kube_dir/config"

kubectl version --client --output=yaml >/dev/null

for _ in $(seq 1 60); do
  if kubectl cluster-info >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

kubectl cluster-info >/dev/null

exec sleep infinity
