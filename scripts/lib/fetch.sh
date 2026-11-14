#!/usr/bin/env bash
# fetch.sh — verified HTTPS downloads (sourceable; see scripts/fetch).
#
# Every out-of-band artifact (fonts, completions, helper scripts, the mise
# bootstrap archive) is pinned to an HTTPS URL and a SHA-256 digest kept in a
# tracked file. There is no "latest" fallback: a missing or mismatched digest is
# an error, not a reason to install something unverified.
#
# Target: bash 3.2 (macOS) and modern bash on Linux. Never sourced with `set -u`
# assumptions: all variables have defaults.

# Refuse anything larger than this unless the caller overrides it (the Nerd Font
# zip is ~112 MiB).
: "${FETCH_MAX_BYTES:=268435456}"

fetch_sha256() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{ print $1 }'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{ print $1 }'
  else
    printf 'error: need sha256sum or shasum to verify downloads\n' >&2
    return 2
  fi
}

fetch_size() {
  wc -c <"$1" | tr -d '[:space:]'
}

fetch_lower() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

# fetch_verified <https-url> <dest> <sha256> [mode]
# Downloads to a temporary file next to <dest>, verifies size and digest, then
# renames into place. Partial or mismatched files are always removed.
fetch_verified() {
  __fetch_url="$1"
  __fetch_dest="$2"
  __fetch_sha="$(fetch_lower "$3")"
  __fetch_mode="${4:-}"

  case "$__fetch_url" in
    https://*) ;;
    *)
      printf 'error: refusing non-HTTPS download: %s\n' "$__fetch_url" >&2
      return 2
      ;;
  esac
  if [ -z "$__fetch_dest" ] || [ -z "$__fetch_sha" ]; then
    printf 'error: fetch_verified needs a destination and a SHA-256 digest\n' >&2
    return 2
  fi
  case "$__fetch_sha" in
    *[!0-9a-f]* | '')
      printf 'error: malformed SHA-256 digest for %s: %s\n' "$__fetch_dest" "$__fetch_sha" >&2
      return 2
      ;;
  esac
  if ! command -v curl >/dev/null 2>&1; then
    printf 'error: curl is required to download %s\n' "$__fetch_url" >&2
    return 2
  fi

  mkdir -p "$(dirname "$__fetch_dest")" || return 1
  __fetch_tmp="$(dirname "$__fetch_dest")/.$(basename "$__fetch_dest").part.$$"

  if ! curl --proto '=https' --tlsv1.2 -fsSL \
    --connect-timeout 20 --max-time 600 --retry 2 \
    --max-filesize "$FETCH_MAX_BYTES" \
    -o "$__fetch_tmp" "$__fetch_url"; then
    rm -f "$__fetch_tmp"
    printf 'error: download failed: %s\n' "$__fetch_url" >&2
    return 1
  fi

  __fetch_bytes="$(fetch_size "$__fetch_tmp")"
  if [ "${__fetch_bytes:-0}" -eq 0 ]; then
    rm -f "$__fetch_tmp"
    printf 'error: download was empty: %s\n' "$__fetch_url" >&2
    return 1
  fi
  if [ "$__fetch_bytes" -gt "$FETCH_MAX_BYTES" ]; then
    rm -f "$__fetch_tmp"
    printf 'error: download exceeds %s bytes: %s\n' "$FETCH_MAX_BYTES" "$__fetch_url" >&2
    return 1
  fi

  __fetch_actual="$(fetch_sha256 "$__fetch_tmp")" || {
    rm -f "$__fetch_tmp"
    return 2
  }
  if [ "$__fetch_actual" != "$__fetch_sha" ]; then
    rm -f "$__fetch_tmp"
    printf 'error: SHA-256 mismatch for %s\n  expected: %s\n  actual:   %s\n' \
      "$__fetch_url" "$__fetch_sha" "$__fetch_actual" >&2
    return 1
  fi

  if [ -n "$__fetch_mode" ]; then
    if ! chmod "$__fetch_mode" "$__fetch_tmp"; then
      rm -f "$__fetch_tmp"
      return 1
    fi
  fi

  mv "$__fetch_tmp" "$__fetch_dest"
}
