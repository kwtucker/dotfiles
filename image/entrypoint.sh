#!/usr/bin/env bash
# image/entrypoint.sh — default to sleep infinity under k8s, exec any command given.
set -euo pipefail

# mise shims first so kubectl/nvim/go resolve inside `kubectl exec` too.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$HOME/go/bin:$PATH"

if [ "$#" -eq 0 ]; then
  exec sleep infinity
fi
exec "$@"
