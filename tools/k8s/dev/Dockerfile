FROM docker:27-cli

ARG KUBECTL_VERSION="v1.30.6"
ARG K3D_VERSION="v5.7.4"
ARG KOMPOSE_VERSION="v1.34.0"
ARG TARGETARCH

RUN apk add --no-cache bash ca-certificates coreutils curl git openssl \
    && update-ca-certificates

RUN set -eux; \
    arch="${TARGETARCH:-}"; \
    if [ -z "$arch" ]; then \
      m="$(uname -m)"; \
      case "$m" in \
        x86_64) arch="amd64" ;; \
        aarch64) arch="arm64" ;; \
        *) echo "Unsupported arch: $m"; exit 1 ;; \
      esac; \
    fi; \
    curl -fsSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${arch}/kubectl"; \
    chmod +x /usr/local/bin/kubectl; \
    curl -fsSL -o /usr/local/bin/k3d "https://github.com/k3d-io/k3d/releases/download/${K3D_VERSION}/k3d-linux-${arch}"; \
    chmod +x /usr/local/bin/k3d; \
    curl -fsSL -o /usr/local/bin/kompose "https://github.com/kubernetes/kompose/releases/download/${KOMPOSE_VERSION}/kompose-linux-${arch}"; \
    chmod +x /usr/local/bin/kompose

COPY tools/k8s/dev/entrypoint.sh /usr/local/bin/fc-k8s-dev-entrypoint
RUN chmod +x /usr/local/bin/fc-k8s-dev-entrypoint

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/fc-k8s-dev-entrypoint"]
