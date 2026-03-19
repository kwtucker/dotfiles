#!/bin/bash
set -euo pipefail
set -x

echo "🔹 Running full DevPod install"

# XDG directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"

# Nix setup
echo "🔹 Setting up Nix configuration"
mkdir -p "$XDG_CONFIG_HOME/nixpkgs"
ln -sf "$PWD/nix/config.nix" "$XDG_CONFIG_HOME/nixpkgs/config.nix"

echo "🔹 Installing Nix packages"
nix-env -iA nixpkgs.myPackages || echo "⚠️ nix-env failed (maybe packages already installed)"

# Install all dotfiles modules
echo "🔹 Installing dotfiles modules"
make all || echo "⚠️ make all failed, continuing anyway"
