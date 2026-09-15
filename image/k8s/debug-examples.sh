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
# --profile=general: explicit (kubectl's implicit legacy default is deprecated).
# Expect a warning when the target pod runs non-root (as ours does): the
# profile's extra capabilities won't fully apply. Stay non-root + `sudo -i`
# for individual commands, or re-run with a --custom profile granting
# securityContext.runAsUser 0 when you truly need root in the target.
kubectl -n $NS debug -it pod/\$POD \\
  --image=$IMAGE --profile=general --share-processes --target=\$CONTAINER -- zsh
# only if you truly need root in there:
#   sudo -i

# ── First `debug` fails with Forbidden? ────────────────────────────────────
# `kubectl debug` needs get pods + update pods/ephemeralcontainers. If your
# context is a bare ServiceAccount (e.g. system:serviceaccount:default:default),
# switch to an admin context — or, RANCHER-DESKTOP-LOCAL ONLY, grant it:
# kubectl create clusterrolebinding default-admin --clusterrole=cluster-admin --serviceaccount=default:default
# NEVER apply that binding on a shared/corp cluster.

# ── No clone needed (work machines without git auth) ─────────────────────
kubectl -n $NS apply -f https://raw.githubusercontent.com/kwtucker/dotfiles/main/image/k8s/dev-pod.yaml

# ── Update to latest published image ─────────────────────────────────────
kubectl -n $NS rollout restart deploy/workspace
EOF
