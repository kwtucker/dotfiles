#!/usr/bin/env bash
# image/entrypoint.sh — default to sleep infinity under k8s, exec any command given.
set -euo pipefail

# mise shims first so kubectl/nvim/go resolve inside `kubectl exec` too.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$HOME/go/bin:$PATH"

# Self-heal the editor bootstrap: if the image ever ships without lazy.nvim
# (or a volume overlays an empty data dir), clone it here — seconds, once
# per container — instead of failing later with E5113. Normally a no-op
# (~1ms test). Remaining plugins self-install async via Lazy on first nvim
# launch; Mason tools via mason-tool-installer.
LAZY_DIR="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_DIR/lua" ]; then
  echo "entrypoint: lazy.nvim missing — cloning (one-time self-heal)..." >&2
  mkdir -p "$(dirname "$LAZY_DIR")"
  git clone --filter=blob:none --branch=stable \
    https://github.com/folke/lazy.nvim.git "$LAZY_DIR" >&2
fi

if [ "$#" -eq 0 ]; then
  exec sleep infinity
fi
exec "$@"
