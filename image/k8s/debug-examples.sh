#!/usr/bin/env bash
# image/k8s/debug-examples.sh — copy/paste recipes for the workspace image.
# Public image: no docker login, no imagePullSecret anywhere below.
set -euo pipefail

IMAGE="${IMAGE:-ghcr.io/kwtucker/workspace:latest}"
NS="${NS:-default}"

cat <<EOF
# ── Standalone debug pod (throwaway, no PVC) ──────────────────────────────
kubectl -n $NS run debug --image=$IMAGE --restart=Never -- sleep infinity
kubectl -n $NS wait pod/debug --for=condition=Ready --timeout=120s
kubectl -n $NS exec -it debug -- zsh

# ── Long-running remote-dev workspace (with PVC, Go caches persist) ──────
kubectl -n $NS apply -f dev-pod.yaml
kubectl -n $NS rollout status deploy/workspace
kubectl -n $NS exec -it deploy/workspace -- zsh
# inside: tmux new -s work

# ── Ephemeral debug container inside a failing pod ────────────────────────
# POD=... CONTAINER=...
kubectl -n $NS debug -it pod/\$POD \\
  --image=$IMAGE --share-processes --target=\$CONTAINER -- zsh
# only if you truly need root in there:
#   sudo -i

# ── No clone needed (work machines without git auth) ─────────────────────
kubectl -n $NS apply -f https://raw.githubusercontent.com/kwtucker/dotfiles/main/image/k8s/dev-pod.yaml

# ── Update to latest published image ─────────────────────────────────────
kubectl -n $NS rollout restart deploy/workspace
EOF
