#!/bin/sh
# devenv-entrypoint — UID-agnostic bootstrap for the dotfiles-devenv image.
#
# Ephemeral debug containers and restricted-PSS workloads often run as
# arbitrary UIDs with no passwd entry and no prepared $HOME. This script
# lays the baked-in dotfiles (/opt/dotfiles) into whatever $HOME we get,
# then execs the requested command. Config symlinks only — no downloads,
# so it is safe to run offline on every container start.
set -eu

# Fall back to a writable per-UID home when $HOME is unset or not writable.
if [ -z "${HOME:-}" ] || [ ! -d "${HOME}" ] || [ ! -w "${HOME}" ]; then
  export HOME="/tmp/home-$(id -u)"
  mkdir -p "$HOME"
fi
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$HOME/.local/bin"

DOTFILES=/opt/dotfiles

# Symlink every module dir into ~/.config. Mirrors `make all` minus everything
# that needs the network (fonts download, TPM clone, antigen fetch are baked
# for the dev user at image build time instead).
for src in "$DOTFILES"/*/; do
  mod=${src%/}
  mod=${mod##*/}
  [ -f "$src/Makefile" ] || continue
  case "$mod" in
    bin) continue ;;    # owns ~/.local/bin (created above), not a config dir
    fonts) continue ;;  # no config files; fonts are baked at build time
  esac
  ln -sfn "$src" "$XDG_CONFIG_HOME/$mod"
done

# zsh reads ~/.zshenv outside XDG — link it too when the module ships one.
if [ -f "$DOTFILES/zsh/zshenv" ]; then
  ln -sf "$DOTFILES/zsh/zshenv" "$HOME/.zshenv"
fi

exec "$@"
