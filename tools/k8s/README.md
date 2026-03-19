# Docker Compose K8s + VSCode Remote Debug

This directory provides:

- `docker-compose.k8s.yml` (repo root): a Docker Compose stack that launches a local Kubernetes cluster (k3d) inside Docker.
- `docker-compose.app.yml` (repo root): a second Docker Compose file used as input to deploy an application onto that cluster (via `kompose`).
- VSCode config to attach remote debug to that application from inside the dev container.

Local usage (from repo root):

1) Launch the Kubernetes cluster via Docker Compose.

If your host has `docker compose`, use it. Otherwise, use the wrapper that runs Compose in a container:

```bash
bash tools/k8s/compose.sh -f docker-compose.k8s.yml up -d --build
```

Note: `docker-compose.k8s.yml` uses `network_mode: host` so the k3d-generated kubeconfig works from inside the dev container.

2) Open the repo in VSCode and `Dev Containers: Reopen in Container`.
3) In the container terminal, deploy the app:

```bash
bash tools/k8s/deploy_compose_to_k8s.sh docker-compose.app.yml
```

4) Start port-forwarding (VSCode tasks):

- `k8s: port-forward debug` (9229)
- `k8s: port-forward http` (3000)

5) Debug (VSCode): run `K8s: Attach debug-app (Node)`.
