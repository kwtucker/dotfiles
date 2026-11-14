#!/usr/bin/env bash
# common.sh — shared helpers for the read-only dotfiles state commands.
#
# Target: bash 3.2 (macOS) and modern bash on Linux. No associative arrays,
# no mapfile, no ${var,,}, and no writes. Entrypoints own `set -e`.

# Sourced more than once (e.g. scripts/state and links.sh) — load once.
if [ -n "${DOTFILES_COMMON_SH:-}" ]; then
  # Sourced twice by a caller; return to it. The fallback keeps a direct
  # execution from continuing into the rest of the library.
  # shellcheck disable=SC2317
  return 0 2>/dev/null || exit 0
fi
DOTFILES_COMMON_SH=1

# ── Paths ─────────────────────────────────────────────────────────────────────
# DOTFILES_ROOT may be overridden by tests or wrappers. Otherwise resolve from
# this file: scripts/lib/common.sh -> repository root.
__dotfiles_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_ROOT="${DOTFILES_ROOT:-$(cd "$__dotfiles_lib_dir/../.." && pwd -P)}"
export DOTFILES_ROOT

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME

DOTFILES_STATE_DIR="${XDG_STATE_HOME}/dotfiles"
DOTFILES_STAMP="${DOTFILES_STATE_DIR}/last-applied"

MISE_DATA_DIR="${MISE_DATA_DIR:-$HOME/.local/share/mise}"
COPILOT_HOME="${COPILOT_HOME:-$HOME/.copilot}"

# ── Output ────────────────────────────────────────────────────────────────────
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_DIM=$'\033[2m'
  C_RED=$'\033[0;31m'
  C_GREEN=$'\033[0;32m'
  C_YELLOW=$'\033[0;33m'
else
  C_RESET=''
  C_BOLD=''
  C_DIM=''
  C_RED=''
  C_GREEN=''
  C_YELLOW=''
fi

# JSON_MODE is set by entrypoints before recording results.
JSON_MODE=0

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0
RESULT_STATUS=()
RESULT_CHECK=()
RESULT_MESSAGE=()
RESULT_FIX=()

section() {
  [ "$JSON_MODE" = "1" ] && return 0
  printf '\n%s%s%s\n' "$C_BOLD" "$1" "$C_RESET"
}

# record_result PASS|WARN|FAIL <check> <message> [remediation]
record_result() {
  __status="$1"
  __check="$2"
  __message="$3"
  __fix="${4:-}"

  case "$__status" in
    PASS)
      PASS_COUNT=$((PASS_COUNT + 1))
      __color="$C_GREEN"
      ;;
    WARN)
      WARN_COUNT=$((WARN_COUNT + 1))
      __color="$C_YELLOW"
      ;;
    FAIL)
      FAIL_COUNT=$((FAIL_COUNT + 1))
      __color="$C_RED"
      ;;
    *) return 2 ;;
  esac

  RESULT_STATUS[${#RESULT_STATUS[@]}]="$__status"
  RESULT_CHECK[${#RESULT_CHECK[@]}]="$__check"
  RESULT_MESSAGE[${#RESULT_MESSAGE[@]}]="$__message"
  RESULT_FIX[${#RESULT_FIX[@]}]="$__fix"

  [ "$JSON_MODE" = "1" ] && return 0
  printf '  %s%-4s%s %-24s %s\n' "$__color" "$__status" "$C_RESET" "$__check" "$__message"
  if [ -n "$__fix" ] && [ "$__status" != "PASS" ]; then
    printf '       %sfix:%s %s\n' "$C_DIM" "$C_RESET" "$__fix"
  fi
}

# ── Small portable helpers ────────────────────────────────────────────────────
have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

is_absolute() {
  case "$1" in
    /*) return 0 ;;
    *) return 1 ;;
  esac
}

# Quote a value for a copy/paste remediation command.
sh_quote() {
  printf '%s' "$1" | sed "s/'/'\\\\''/g" | sed "s/^/'/; s/\$/'/"
}

file_mode() {
  if stat -c '%a' "$1" >/dev/null 2>&1; then
    stat -c '%a' "$1"
  else
    stat -f '%Lp' "$1"
  fi
}

json_escape() {
  # Messages are single-line diagnostics; flatten embedded newlines and tabs so
  # the output stays valid JSON without requiring jq.
  printf '%s' "$1" | tr '\n\t' '  ' | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

json_items() {
  __first=1
  printf '['
  for __item in "$@"; do
    [ "$__first" = "1" ] || printf ', '
    __first=0
    printf '"%s"' "$(json_escape "$__item")"
  done
  printf ']'
}

# Turn a space-separated word list into a JSON array.
json_words() {
  __first=1
  printf '['
  for __word in $1; do
    [ "$__first" = "1" ] || printf ', '
    __first=0
    printf '"%s"' "$(json_escape "$__word")"
  done
  printf ']'
}

json_bool() {
  if [ "$1" = "1" ]; then printf 'true'; else printf 'false'; fi
}

# ── Stamp (v1 = raw HEAD, v2 = key=value lines) ───────────────────────────────
# shellcheck source=scripts/lib/stamp.sh
. "$__dotfiles_lib_dir/stamp.sh"

# ── Make metadata (single source of truth for modules and paths) ──────────────
make_meta() {
  (cd "$DOTFILES_ROOT" && make -s --no-print-directory "$1" 2>/dev/null)
}

MODULES_ENABLED=""
MODULES_OPTIONAL=""
FONT_DIR=""

load_modules() {
  MODULES_ENABLED=""
  MODULES_OPTIONAL=""
  __meta="$(make_meta .list.modules)" || return 1
  [ -n "$__meta" ] || return 1

  MODULES_ENABLED="$(printf '%s\n' "$__meta" | awk -F '\t' '$1 == "enabled" { printf "%s ", $2 }')"
  MODULES_ENABLED="${MODULES_ENABLED% }"
  MODULES_OPTIONAL="$(printf '%s\n' "$__meta" | awk -F '\t' '$1 == "optional" { printf "%s ", $2 }')"
  MODULES_OPTIONAL="${MODULES_OPTIONAL% }"
  [ -n "$MODULES_ENABLED" ]
}

default_font_dir() {
  case "$(uname -s)" in
    Darwin) printf '%s/Library/Fonts' "$HOME" ;;
    *) printf '%s/fonts' "$XDG_DATA_HOME" ;;
  esac
}

load_paths() {
  FONT_DIR=""
  __meta="$(make_meta .list.paths)" || true
  if [ -n "$__meta" ]; then
    FONT_DIR="$(printf '%s\n' "$__meta" | awk -F '\t' '$1 == "font" { print $2; exit }')"
  fi
  [ -n "$FONT_DIR" ] || FONT_DIR="$(default_font_dir)"
}

module_enabled() {
  for __m in $MODULES_ENABLED; do
    [ "$__m" = "$1" ] && return 0
  done
  return 1
}

# Format "a, b, c, and N more" for compact aggregate diagnostics.
summarize_items() {
  __limit="$1"
  shift
  __total=$#
  __i=0
  __out=""
  for __entry in "$@"; do
    __i=$((__i + 1))
    if [ "$__i" -le "$__limit" ]; then
      if [ -n "$__out" ]; then __out="$__out, "; fi
      __out="$__out$__entry"
    fi
  done
  if [ "$__total" -gt "$__limit" ]; then
    __out="$__out, and $((__total - __limit)) more"
  fi
  printf '%s' "$__out"
}
