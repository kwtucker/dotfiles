#!/usr/bin/env bash
# stamp.sh — applied-state stamp helpers (v2 key=value, v1 raw HEAD).
#
# The stamp records the inputs that decide whether the fast path may skip the
# module pass: commit, checkout location, XDG base directories, the ignored local
# override files, and the selected profile + resolved module/tool sets. A stamp is
# only trusted when every recorded input still matches; link health is verified
# separately by `scripts/state check-links`.
#
# v1 (historical): a single commit SHA on one line.
# v2:
#   version=2
#   head=<sha>
#   root=<absolute checkout path>
#   xdg_config=<value>
#   xdg_data=<value>
#   xdg_state=<value>
#   modules_local=<git hash-object | none>
#   mise_local=<git hash-object | none>
#   profile=<name>
#   modules=<space-separated module names>
#   tools=<space-separated backend-qualified mise tool names>
#   applied_at=<UTC ISO 8601>
#
# `profile`, `modules`, and `tools` come from DOTFILES_ACTIVE_PROFILE,
# DOTFILES_MODULES, and DOTFILES_TOOLS when a caller already resolved them
# (install, scripts/state). Otherwise the helpers resolve the active selection
# from `make .list.modules` / `make .list.tools` once and cache it, so a profile
# switch invalidates the fast path even on a matching commit.
#
# The recorded tool list is what lets the installer remove tools owned by a
# module or profile that is no longer selected. Base, shared, unclassified, and
# locally declared tools are never in that removal set; see tools.mk.

DOTFILES_ROOT="${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)}"
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
: "${DOTFILES_STATE_DIR:=$XDG_STATE_HOME/dotfiles}"
: "${DOTFILES_STAMP:=$DOTFILES_STATE_DIR/last-applied}"

# Keys compared by stamp_verify. applied_at is informational only.
STAMP_KEYS="head root xdg_config xdg_data xdg_state modules_local mise_local profile modules tools"

# Read one v2 key, or `head` from a legacy v1 stamp. Prints nothing on miss.
read_stamp_key() {
  [ -r "$DOTFILES_STAMP" ] || return 1
  __stamp_key="$1"
  if grep -q '^version=' "$DOTFILES_STAMP" 2>/dev/null; then
    sed -n "s/^${__stamp_key}=//p" "$DOTFILES_STAMP" | head -n 1
  elif [ "$__stamp_key" = "head" ]; then
    head -n 1 "$DOTFILES_STAMP"
  else
    return 1
  fi
}

stamp_head() {
  read_stamp_key head
}

# Content hash of an ignored/tracked local override file, or "none".
stamp_git_hash() {
  if [ -f "$1" ] && command -v git >/dev/null 2>&1; then
    git hash-object -- "$1" 2>/dev/null || printf 'none'
  else
    printf 'none'
  fi
}

# Resolve the active profile and module list once. Callers that already queried
# Make may export DOTFILES_ACTIVE_PROFILE / DOTFILES_MODULES; everything else
# asks Make directly so the stamp always compares against the real selection.
STAMP_META_LOADED=0
STAMP_META_PROFILE="full"
STAMP_META_MODULES=""
STAMP_META_TOOLS=""

stamp_load_meta() {
  [ "$STAMP_META_LOADED" = "1" ] && return 0
  STAMP_META_LOADED=1

  if [ -n "${DOTFILES_ACTIVE_PROFILE:-}" ] || [ -n "${DOTFILES_MODULES:-}" ]; then
    STAMP_META_PROFILE="${DOTFILES_ACTIVE_PROFILE:-full}"
    STAMP_META_MODULES="${DOTFILES_MODULES:-}"
  else
    __stamp_meta="$(cd "$DOTFILES_ROOT" && make -s --no-print-directory .list.modules 2>/dev/null)" || return 0
    STAMP_META_PROFILE="$(printf '%s\n' "$__stamp_meta" | awk -F '\t' '$1 == "profile" { print $2; exit }')"
    STAMP_META_MODULES="$(printf '%s\n' "$__stamp_meta" | awk -F '\t' '$1 == "enabled" { printf "%s ", $2 }')"
    STAMP_META_MODULES="${STAMP_META_MODULES% }"
    [ -n "$STAMP_META_PROFILE" ] || STAMP_META_PROFILE="full"
  fi

  if [ -n "${DOTFILES_TOOLS:-}" ]; then
    STAMP_META_TOOLS="$DOTFILES_TOOLS"
  else
    __stamp_tools="$(cd "$DOTFILES_ROOT" && make -s --no-print-directory .list.tools 2>/dev/null)" || return 0
    STAMP_META_TOOLS="$(printf '%s\n' "$__stamp_tools" | awk -F '\t' '$1 == "active" { printf "%s ", $2 }')"
    STAMP_META_TOOLS="${STAMP_META_TOOLS% }"
  fi
}

# Current value of a stamp field.
stamp_field() {
  case "$1" in
    version) printf '2' ;;
    head) git -C "$DOTFILES_ROOT" rev-parse HEAD 2>/dev/null || printf 'unknown' ;;
    root) printf '%s' "$DOTFILES_ROOT" ;;
    xdg_config) printf '%s' "$XDG_CONFIG_HOME" ;;
    xdg_data) printf '%s' "$XDG_DATA_HOME" ;;
    xdg_state) printf '%s' "$XDG_STATE_HOME" ;;
    modules_local) stamp_git_hash "$DOTFILES_ROOT/modules.local.mk" ;;
    mise_local) stamp_git_hash "$DOTFILES_ROOT/mise.local.toml" ;;
    profile)
      stamp_load_meta
      printf '%s' "$STAMP_META_PROFILE"
      ;;
    modules)
      stamp_load_meta
      printf '%s' "$STAMP_META_MODULES"
      ;;
    tools)
      stamp_load_meta
      printf '%s' "$STAMP_META_TOOLS"
      ;;
    applied_at) date -u +%Y-%m-%dT%H:%M:%SZ ;;
    *) return 2 ;;
  esac
}

# 0 = the stamp is v2 and every recorded input matches the current environment.
# 1 = absent, legacy, unreadable, or stale. Sets STAMP_DIFF and STAMP_DIFF_DETAIL,
# which callers (install, scripts/state) read for their own reporting.
# shellcheck disable=SC2034
stamp_verify() {
  STAMP_DIFF=""
  STAMP_DIFF_DETAIL=""

  if [ ! -r "$DOTFILES_STAMP" ]; then
    STAMP_DIFF="no applied-state stamp"
    return 1
  fi
  if [ "$(read_stamp_key version 2>/dev/null || true)" != "2" ]; then
    STAMP_DIFF="legacy or unreadable stamp"
    STAMP_DIFF_DETAIL="stamp format is not v2; re-run ./install"
    return 1
  fi

  __stamp_expected_head="$(stamp_field head)"
  if [ "$__stamp_expected_head" = "unknown" ]; then
    STAMP_DIFF="cannot resolve git HEAD"
    STAMP_DIFF_DETAIL="checkout is not a readable git repository: $DOTFILES_ROOT"
    return 1
  fi

  for __stamp_key in $STAMP_KEYS; do
    __stamp_actual="$(read_stamp_key "$__stamp_key" 2>/dev/null || true)"
    __stamp_expected="$(stamp_field "$__stamp_key")"
    if [ "$__stamp_actual" != "$__stamp_expected" ]; then
      STAMP_DIFF="$__stamp_key changed"
      STAMP_DIFF_DETAIL="$__stamp_key: recorded '${__stamp_actual:-none}', now '${__stamp_expected:-none}'"
      return 1
    fi
  done

  return 0
}

# Atomically record the current inputs. Call only after a successful module pass.
stamp_write() {
  mkdir -p "$DOTFILES_STATE_DIR" || {
    printf 'error: cannot create state directory: %s\n' "$DOTFILES_STATE_DIR" >&2
    return 1
  }

  __stamp_tmp="$DOTFILES_STAMP.tmp.$$"
  if {
    printf 'version=2\n'
    for __stamp_key in $STAMP_KEYS; do
      printf '%s=%s\n' "$__stamp_key" "$(stamp_field "$__stamp_key")"
    done
    printf 'applied_at=%s\n' "$(stamp_field applied_at)"
  } >"$__stamp_tmp"; then
    if mv "$__stamp_tmp" "$DOTFILES_STAMP"; then
      return 0
    fi
  fi

  rm -f "$__stamp_tmp"
  printf 'error: cannot write applied-state stamp: %s\n' "$DOTFILES_STAMP" >&2
  return 1
}
