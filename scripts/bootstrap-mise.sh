#!/usr/bin/env bash
# bootstrap-mise.sh — install a pinned mise release on a fresh machine.
#
# The release tag is pinned below; the archive is downloaded from that tag and
# verified against the release's SHASUMS256.txt before anything is installed.
# There is no `curl | sh` fallback and no "latest" resolution: if the checksum
# file cannot be fetched, the script fails.
#
#   scripts/bootstrap-mise.sh [--force]
#
# Overrides (for a deliberate bump or a local test):
#   MISE_BOOTSTRAP_VERSION=v2026.11.8
#   MISE_BOOTSTRAP_DEST=$HOME/.local/bin/mise
set -euo pipefail

MISE_BOOTSTRAP_VERSION="${MISE_BOOTSTRAP_VERSION:-v2026.11.8}"
MISE_BOOTSTRAP_DEST="${MISE_BOOTSTRAP_DEST:-$HOME/.local/bin/mise}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/fetch.sh
. "$SCRIPT_DIR/lib/fetch.sh"

FORCE=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --force | -f) FORCE=1 ;;
    -h | --help)
      cat <<'EOF'
usage: scripts/bootstrap-mise.sh [--force]

Installs the pinned mise release to $HOME/.local/bin/mise after verifying the
release checksum. --force reinstalls over an existing binary.

Overrides: MISE_BOOTSTRAP_VERSION (v2026.11.8), MISE_BOOTSTRAP_DEST.
EOF
      exit 0
      ;;
    *)
      printf 'error: unknown option: %s\n' "$1" >&2
      exit 2
      ;;
  esac
  shift
done

case "$MISE_BOOTSTRAP_VERSION" in
  v[0-9]*) ;;
  *)
    printf 'error: MISE_BOOTSTRAP_VERSION must look like v2026.11.8 (got: %s)\n' \
      "$MISE_BOOTSTRAP_VERSION" >&2
    exit 2
    ;;
esac

if [ -d "$MISE_BOOTSTRAP_DEST" ]; then
  printf 'error: destination is a directory: %s\n' "$MISE_BOOTSTRAP_DEST" >&2
  exit 1
fi
if [ -x "$MISE_BOOTSTRAP_DEST" ] && [ "$FORCE" != "1" ]; then
  printf 'mise already installed at %s (use --force to reinstall)\n' "$MISE_BOOTSTRAP_DEST"
  exit 0
fi

case "$(uname -s)" in
  Linux) __os=linux ;;
  Darwin) __os=macos ;;
  *)
    printf 'error: unsupported operating system for mise bootstrap: %s\n' "$(uname -s)" >&2
    exit 1
    ;;
esac
case "$(uname -m)" in
  x86_64 | amd64) __arch=x64 ;;
  arm64 | aarch64) __arch=arm64 ;;
  *)
    printf 'error: unsupported architecture for mise bootstrap: %s\n' "$(uname -m)" >&2
    exit 1
    ;;
esac

__asset="mise-${MISE_BOOTSTRAP_VERSION}-${__os}-${__arch}.tar.gz"
__base="https://github.com/jdx/mise/releases/download/${MISE_BOOTSTRAP_VERSION}"

if ! command -v tar >/dev/null 2>&1; then
  printf 'error: tar is required to extract the mise archive\n' >&2
  exit 1
fi

__tmp="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-mise.XXXXXX")" || {
  printf 'error: cannot create a temporary directory\n' >&2
  exit 1
}
trap 'rm -rf "$__tmp"' EXIT HUP INT TERM

printf 'Fetching mise %s (%s-%s)...\n' "$MISE_BOOTSTRAP_VERSION" "$__os" "$__arch"
if ! curl --proto '=https' --tlsv1.2 -fsSL \
  --connect-timeout 20 --max-time 120 --retry 2 \
  -o "$__tmp/SHASUMS256.txt" "$__base/SHASUMS256.txt"; then
  printf 'error: cannot download mise checksums: %s/SHASUMS256.txt\n' "$__base" >&2
  exit 1
fi

__expected="$(awk -v want="$__asset" '
  {
    name = $2
    sub(/^\*/, "", name)
    sub(/^\.\//, "", name)
    if (name == want) { print $1; exit }
  }
' "$__tmp/SHASUMS256.txt")"
if [ -z "$__expected" ]; then
  printf 'error: %s is not listed in the release SHASUMS256.txt\n' "$__asset" >&2
  exit 1
fi

fetch_verified "$__base/$__asset" "$__tmp/$__asset" "$__expected"
tar -xzf "$__tmp/$__asset" -C "$__tmp"

__bin="$(find "$__tmp" -type f -name mise | sed -n '1p')"
if [ -z "$__bin" ]; then
  printf 'error: mise binary not found in %s\n' "$__asset" >&2
  exit 1
fi

__want_version="${MISE_BOOTSTRAP_VERSION#v}"
__reported="$("$__bin" --version 2>/dev/null || true)"
case " $__reported " in
  *" $__want_version "*) ;;
  *)
    printf 'error: downloaded mise does not report version %s (got: %s)\n' \
      "$__want_version" "${__reported:-no output}" >&2
    exit 1
    ;;
esac

mkdir -p "$(dirname "$MISE_BOOTSTRAP_DEST")"
__dest_tmp="$MISE_BOOTSTRAP_DEST.tmp.$$"
if ! cp "$__bin" "$__dest_tmp"; then
  rm -f "$__dest_tmp"
  printf 'error: cannot write %s\n' "$MISE_BOOTSTRAP_DEST" >&2
  exit 1
fi
chmod 755 "$__dest_tmp"
mv "$__dest_tmp" "$MISE_BOOTSTRAP_DEST"

printf 'Installed mise %s at %s\n' "$__want_version" "$MISE_BOOTSTRAP_DEST"
