#!/usr/bin/env bash
# tools.sh — profile tool-ownership helpers (pure; no writes).
#
# install sources this to decide which installed mise tools a profile switch
# should remove. Ownership is declared in tools.mk; this file only compares the
# previous active set with the new one and honours machine-local declarations.
# Base, shared, and unclassified tools are never in the managed set, so they are
# never removed here.

# Print the tool keys from one mise TOML file's [tools] table. Accepts the
# output of `mise config get --file <file> tools`: quoted/bare keys plus
# subtable headers (`[python]`, `["aqua:sharkdp/bat"]`). Value lines inside a
# subtable are skipped, so `version = "3"` is not mistaken for a tool.
mise_local_tool_keys() {
  mise config get --file "$1" tools 2>/dev/null | awk '
    /^[[:space:]]*\[/ {
      line = $0
      sub(/^[[:space:]]*\[/, "", line)
      sub(/\][[:space:]]*$/, "", line)
      if (line ~ /^tools\./) { sub(/^tools\./, "", line) }
      if (line ~ /^"/) { sub(/^"/, "", line); sub(/".*$/, "", line) }
      if (line == "tools") { next }
      print line
      in_sub = 1
      next
    }
    in_sub { next }
    /^[[:space:]]*"/ { line = $0; sub(/^[[:space:]]*"/, "", line); sub(/".*/, "", line); print line; next }
    /^[[:space:]]*[A-Za-z0-9_.-]+[[:space:]]*=/ { line = $0; sub(/[[:space:]]*=.*/, "", line); gsub(/^[[:space:]]+|[[:space:]]+$/, "", line); print line }
  '
}

# Print the tool keys declared across the given machine-local config files.
local_mise_tools() {
  for __file in "$@"; do
    [ -f "$__file" ] || continue
    mise_local_tool_keys "$__file"
  done
}

# 0 when <tool> is declared in the space/newline-separated <local> list.
# Backend-qualified and short names are compared, so a local `jq` entry protects
# `aqua:jqlang/jq` from profile cleanup.
tool_is_local() {
  __needle="$1"
  __local="$2"
  __needle_short="${__needle##*:}"
  __needle_short="${__needle_short##*/}"
  # Deliberate word splitting: <local> is a tool list.
  # shellcheck disable=SC2086
  for __decl in $__local; do
    [ "$__decl" = "$__needle" ] && return 0
    __decl_short="${__decl##*:}"
    __decl_short="${__decl_short##*/}"
    [ "$__decl_short" = "$__needle_short" ] && return 0
  done
  return 1
}

# Print tools present in <old> but absent from <active> that are managed and not
# declared locally. Arguments: <old> <active> <managed> <local>.
profile_removed_tools() {
  __old="$1"
  __active="$2"
  __managed="$3"
  __local="$4"
  __out=""
  # Deliberate word splitting: every argument is a space-separated tool list.
  # shellcheck disable=SC2086
  for __tool in $__old; do
    case " $__active " in
      *" $__tool "*) continue ;;
    esac
    case " $__managed " in
      *" $__tool "*) ;;
      *) continue ;;
    esac
    tool_is_local "$__tool" "$__local" && continue
    __out="$__out $__tool"
  done
  printf '%s' "${__out# }"
}
