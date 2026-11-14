#!/usr/bin/env bash
# links.sh — expected-link model and read-only verification.
#
# The expected set is derived from the enabled modules reported by Make, not by
# parsing the Makefile here. Whole-directory module links follow the convention
# ${XDG_CONFIG_HOME}/<module> -> $DOTFILES_ROOT/<module>; the exceptions below
# are the modules whose links live outside ~/.config.

if [ -z "${DOTFILES_COMMON_SH:-}" ]; then
  DOTFILES_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=scripts/lib/common.sh
  . "$DOTFILES_LIB_DIR/common.sh"
fi

# ── Expected model ────────────────────────────────────────────────────────────
# Parallel arrays: LINK_DEST[i] is the link path, LINK_SRC[i] its target.
LINK_DEST=()
LINK_SRC=()

add_link() {
  LINK_DEST[${#LINK_DEST[@]}]="$1"
  LINK_SRC[${#LINK_SRC[@]}]="$2"
}

build_expected_links() {
  LINK_DEST=()
  LINK_SRC=()

  [ -n "$MODULES_ENABLED" ] || return 1

  for __module in $MODULES_ENABLED; do
    case "$__module" in
      bin)
        # bin/ links every executable (except its Makefile) into ~/.local/bin.
        for __file in "$DOTFILES_ROOT/bin"/*; do
          [ -f "$__file" ] || continue
          __name="$(basename "$__file")"
          [ "$__name" = "Makefile" ] && continue
          [ -x "$__file" ] || continue
          add_link "$HOME/.local/bin/$__name" "$__file"
        done
        ;;
      fonts)
        # Fonts are copied into FONT_DIR, not linked.
        ;;
      agents)
        for __path in \
          skills/conventional-commits \
          skills/go-development \
          skills/caveman \
          skills/temporary-ssh-key \
          instructions/engineering.md; do
          add_link "$HOME/.agents/$__path" "$DOTFILES_ROOT/agents/$__path"
        done
        ;;
      copilot)
        for __file in settings.json mcp-config.json instructions/engineering.instructions.md; do
          add_link "$COPILOT_HOME/$__file" "$DOTFILES_ROOT/copilot/$__file"
        done
        ;;
      *)
        add_link "$XDG_CONFIG_HOME/$__module" "$DOTFILES_ROOT/$__module"
        ;;
    esac

    # Module-specific home-level links.
    case "$__module" in
      zsh)
        add_link "$HOME/.zshenv" "$DOTFILES_ROOT/zsh/zshenv"
        ;;
      whalebyte)
        add_link "$HOME/.local/bin/wbs" "$DOTFILES_ROOT/whalebyte/bin/wbs"
        ;;
    esac
  done

  # install links the global mise config independently of any module.
  add_link "$XDG_CONFIG_HOME/mise/config.toml" "$DOTFILES_ROOT/mise.toml"

  return 0
}

# ── Verification ──────────────────────────────────────────────────────────────
LINK_OK=0
LINK_MISSING=0
LINK_BROKEN=0
LINK_FOREIGN=0
LINK_BLOCKED=0

MISSING_ITEMS=()
BROKEN_ITEMS=()
FOREIGN_ITEMS=()
BLOCKED_ITEMS=()

verify_links() {
  LINK_OK=0
  LINK_MISSING=0
  LINK_BROKEN=0
  LINK_FOREIGN=0
  LINK_BLOCKED=0
  MISSING_ITEMS=()
  BROKEN_ITEMS=()
  FOREIGN_ITEMS=()
  BLOCKED_ITEMS=()

  __i=0
  while [ "$__i" -lt "${#LINK_DEST[@]}" ]; do
    __dest="${LINK_DEST[$__i]}"
    __src="${LINK_SRC[$__i]}"

    if [ ! -e "$__src" ] && [ ! -L "$__src" ]; then
      LINK_BROKEN=$((LINK_BROKEN + 1))
      BROKEN_ITEMS[${#BROKEN_ITEMS[@]}]="$__dest -> $__src (source missing)"
      __i=$((__i + 1))
      continue
    fi

    if [ -L "$__dest" ]; then
      __actual="$(readlink "$__dest")"
      if [ "$__actual" = "$__src" ] && [ -e "$__dest" ]; then
        LINK_OK=$((LINK_OK + 1))
      elif [ "$__actual" = "$__src" ]; then
        LINK_BROKEN=$((LINK_BROKEN + 1))
        BROKEN_ITEMS[${#BROKEN_ITEMS[@]}]="$__dest -> $__actual (target missing)"
      elif [ -e "$__dest" ]; then
        LINK_FOREIGN=$((LINK_FOREIGN + 1))
        FOREIGN_ITEMS[${#FOREIGN_ITEMS[@]}]="$__dest -> $__actual (expected $__src)"
      else
        LINK_BROKEN=$((LINK_BROKEN + 1))
        BROKEN_ITEMS[${#BROKEN_ITEMS[@]}]="$__dest -> $__actual (expected $__src; target missing)"
      fi
    elif [ -e "$__dest" ]; then
      LINK_BLOCKED=$((LINK_BLOCKED + 1))
      if [ -d "$__dest" ]; then
        BLOCKED_ITEMS[${#BLOCKED_ITEMS[@]}]="$__dest (directory; expected link to $__src)"
      else
        BLOCKED_ITEMS[${#BLOCKED_ITEMS[@]}]="$__dest (file; expected link to $__src)"
      fi
    else
      LINK_MISSING=$((LINK_MISSING + 1))
      MISSING_ITEMS[${#MISSING_ITEMS[@]}]="$__dest (expected $__src)"
    fi

    __i=$((__i + 1))
  done
}

# Destinations a default install would refuse to replace.
link_conflict_count() {
  printf '%s' "$((LINK_FOREIGN + LINK_BLOCKED))"
}

# ── Orphans ───────────────────────────────────────────────────────────────────
ORPHAN_ITEMS=()
# Read by scripts/state for `check-links --strict` and the summary line.
# shellcheck disable=SC2034
LINK_ORPHANS=0

is_expected_dest() {
  __i=0
  while [ "$__i" -lt "${#LINK_DEST[@]}" ]; do
    [ "${LINK_DEST[$__i]}" = "$1" ] && return 0
    __i=$((__i + 1))
  done
  return 1
}

is_repo_target() {
  case "$1" in
    "$DOTFILES_ROOT" | "$DOTFILES_ROOT"/*) return 0 ;;
  esac
  return 1
}

add_orphan() {
  __item="$1"
  __i=0
  while [ "$__i" -lt "${#ORPHAN_ITEMS[@]}" ]; do
    [ "${ORPHAN_ITEMS[$__i]}" = "$__item" ] && return 0
    __i=$((__i + 1))
  done
  ORPHAN_ITEMS[${#ORPHAN_ITEMS[@]}]="$__item"
}

check_orphan_path() {
  __link="$1"
  [ -L "$__link" ] || return 0
  __target="$(readlink "$__link")"
  is_repo_target "$__target" || return 0
  is_expected_dest "$__link" && return 0
  add_orphan "$__link -> $__target"
}

list_orphans() {
  ORPHAN_ITEMS=()

  for __entry in "$XDG_CONFIG_HOME"/*; do
    check_orphan_path "$__entry"
  done

  for __entry in "$HOME/.local/bin"/*; do
    check_orphan_path "$__entry"
  done

  check_orphan_path "$HOME/.zshenv"

  if [ -d "$HOME/.agents" ]; then
    while IFS= read -r __link; do
      check_orphan_path "$__link"
    done < <(find "$HOME/.agents" -type l 2>/dev/null)
  fi

  if [ -d "$COPILOT_HOME" ]; then
    while IFS= read -r __link; do
      check_orphan_path "$__link"
    done < <(find "$COPILOT_HOME" -maxdepth 3 -type l 2>/dev/null)
  fi

  # shellcheck disable=SC2034  # read by scripts/state
  LINK_ORPHANS=${#ORPHAN_ITEMS[@]}
}
