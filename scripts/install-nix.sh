#! /usr/bin/env bash

set -euo pipefail

if ! command -v nix >/dev/null 2>&1; then
  echo "Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

echo "Applying Nix environment..."
nix-env -i -f "$(dirname "$0")/../nix/default.nix"
echo "✅ Nix environment installed!"
