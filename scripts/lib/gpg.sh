#!/usr/bin/env bash
# Deploy only gpg-agent.conf; keys and the rest of GNUPGHOME stay machine-local.
set -eu

GPG_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/common.sh
. "$GPG_SCRIPT_DIR/common.sh"

gpg_home="${GNUPGHOME:-$HOME/.gnupg}"
destination="$gpg_home/gpg-agent.conf"
generated="$DOTFILES_ROOT/git/gpg-agent.generated.conf"
template="$DOTFILES_ROOT/git/gpg-agent.conf.in"
pinentry="$MISE_DATA_DIR/shims/pinentry-tty"
link_helper="$GPG_SCRIPT_DIR/link.sh"

case "${1:-}" in
  install)
    if [ ! -x "$pinentry" ]; then
      printf 'Skipping GPG setup: missing mise shim %s\n' "$pinentry"
      printf 'Install conda:gnupg and conda:pinentry, run mise reshim, then make -C git gpg-install.\n'
      exit 0
    fi

    # Preflight before changing the generated source: it may already be linked.
    "$link_helper" preflight_file "$template" "$destination"
    umask 077
    temporary="$(mktemp "$generated.tmp.XXXXXX")"
    trap 'rm -f "$temporary"' EXIT
    replacement="$(printf '%s' "$pinentry" | sed 's/[\\&|]/\\&/g')"
    sed "s|@PINENTRY@|$replacement|g" "$template" >"$temporary"
    mv "$temporary" "$generated"
    "$link_helper" link_file "$generated" "$destination"
    ;;
  clean)
    # Do not prune another owned config, foreign links, or real files/directories.
    if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$generated" ]; then
      "$link_helper" prune_link "$destination"
    fi
    ;;
  *)
    printf 'Usage: %s install|clean\n' "$0" >&2
    exit 2
    ;;
esac
