#!/usr/bin/env bash
set -euo pipefail

compose_image="${COMPOSE_IMAGE:-docker/compose:latest}"

exec docker run --rm -t \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "${PWD}:${PWD}" \
  -w "${PWD}" \
  "${compose_image}" \
  "$@"
