#!/usr/bin/env bash
# link.sh — conflict-safe, ownership-aware symlink deployment.
#
#   scripts/lib/link.sh [--adopt] link_dir SRC DEST
#   scripts/lib/link.sh [--adopt] link_file SRC DEST
#   scripts/lib/link.sh preflight_dir SRC DEST
#   scripts/lib/link.sh preflight_file SRC DEST
#
# Semantics:
#   absent destination             -> create the link
#   owned link, resolves to SRC    -> no-op
#   owned link, other/dangling     -> repair (no backup)
#   foreign link / file / dir      -> refuse (or adopt)
#   socket / fifo / device         -> always refuse
#
# "Owned" means the link target resolves inside DOTFILES_ROOT. A destination
# directory is never deleted: adoption moves it into the backup directory.
#
# Environment:
#   DOTFILES_ADOPT=1       adopt conflicting destinations (back up, then link)
#   DOTFILES_BACKUP_ROOT   backup parent
#                          (default: $XDG_STATE_HOME/dotfiles/backups)
#   DOTFILES_BACKUP_ID     backup directory name (default: UTC timestamp)
#
# Exit codes: 0 ok, 1 refused conflict, 2 usage or fatal source/parent error.

set -eu

LINK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/common.sh
. "$LINK_DIR/common.sh"

LINK_ADOPT="${DOTFILES_ADOPT:-0}"
LINK_BACKUP_ROOT="${DOTFILES_BACKUP_ROOT:-$DOTFILES_STATE_DIR/backups}"

link_usage() {
  cat <<'EOF'
Usage: scripts/lib/link.sh [--adopt] <command> SRC DEST

Commands:
  link_dir        Create, keep, or repair a directory link
  link_file       Create, keep, or repair a file link
  preflight_dir   Check a directory link without changing anything
  preflight_file  Check a file link without changing anything

Options:
  --adopt         Back up and replace a conflicting destination
                  (same as DOTFILES_ADOPT=1)
  -h, --help      Show this help

Exit codes:
  0  linked, repaired, or already correct
  1  refused conflict (existing foreign link/file/directory)
  2  usage error, missing source, or unsafe parent/special file
EOF
}

# Human-readable description of whatever currently occupies a path.
link_describe() {
  if [ -L "$1" ]; then
    printf 'symlink -> %s' "$(readlink "$1")"
  elif [ -d "$1" ]; then
    printf 'directory'
  elif [ -f "$1" ]; then
    printf 'regular file'
  elif [ -S "$1" ]; then
    printf 'socket'
  elif [ -p "$1" ]; then
    printf 'named pipe'
  elif [ -b "$1" ]; then
    printf 'block device'
  elif [ -c "$1" ]; then
    printf 'character device'
  else
    printf 'unknown file type'
  fi
}

link_die_usage() {
  printf 'error: %s\n' "$*" >&2
  link_usage >&2
  exit 2
}

link_fatal() {
  printf 'error: %s\n' "$*" >&2
  exit 2
}

# Turn an absolute path into an absolute path without "." or ".." segments.
# Lexical only: the target may not exist (dangling links are still owned).
link_normalize() {
  __in="$1"
  __rest="$1"
  __out=""
  case "$__in" in
    /*) ;;
    *) link_fatal "internal error: expected an absolute path: $__in" ;;
  esac
  while [ -n "$__rest" ]; do
    case "$__rest" in
      */*)
        __seg="${__rest%%/*}"
        __rest="${__rest#*/}"
        ;;
      *)
        __seg="$__rest"
        __rest=""
        ;;
    esac
    case "$__seg" in
      '' | .) ;;
      ..) __out="${__out%/*}" ;;
      *) __out="$__out/$__seg" ;;
    esac
  done
  printf '%s' "${__out:-/}"
}

# Absolute interpretation of a link target, relative to the link's directory.
link_target_path() {
  __target="$1"
  __link="$2"
  case "$__target" in
    /*) printf '%s' "$__target" ;;
    *) printf '%s/%s' "$(dirname "$__link")" "$__target" ;;
  esac
}

link_is_owned() {
  __path="$(link_normalize "$1")"
  case "$__path" in
    "$DOTFILES_ROOT" | "$DOTFILES_ROOT"/*) return 0 ;;
  esac
  return 1
}

link_conflict() {
  printf 'conflict: %s exists (%s); expected a link to %s\n' \
    "$1" "$(link_describe "$1")" "$2" >&2
  printf '  fix: move it aside and re-run, or re-run with DOTFILES_ADOPT=1 to back it up under %s\n' \
    "$LINK_BACKUP_ROOT" >&2
}

# 0 = safe (no-op or repairable), 1 = adoptable conflict, 2 = fatal.
link_check() {
  __kind="$1"
  __src="$2"
  __dest="$3"

  case "$__kind" in
    dir)
      [ -d "$__src" ] || link_fatal "source directory is missing: $__src"
      ;;
    file)
      [ -f "$__src" ] || link_fatal "source file is missing: $__src"
      ;;
    *)
      link_fatal "unknown link kind: $__kind"
      ;;
  esac

  __parent="$(dirname "$__dest")"
  if [ -L "$__parent" ] && [ ! -d "$__parent" ]; then
    link_fatal "destination parent is a dangling symlink: $__parent"
  fi
  if [ -e "$__parent" ] && [ ! -d "$__parent" ]; then
    link_fatal "destination parent is not a directory: $__parent"
  fi

  if [ -L "$__dest" ]; then
    if link_is_owned "$(link_target_path "$(readlink "$__dest")" "$__dest")"; then
      return 0
    fi
    return 1
  fi

  if [ -S "$__dest" ] || [ -p "$__dest" ] || [ -b "$__dest" ] || [ -c "$__dest" ]; then
    link_fatal "refusing to replace a special file: $__dest ($(link_describe "$__dest"))"
  fi

  if [ -e "$__dest" ]; then
    return 1
  fi

  return 0
}

# Move an existing destination into the per-run backup directory.
link_backup() {
  __dest="$1"
  __id="${DOTFILES_BACKUP_ID:-$(date -u +%Y%m%dT%H%M%SZ)}"
  __root="$LINK_BACKUP_ROOT/$__id"

  case "$__dest" in
    "$HOME"/*) __rel="${__dest#"$HOME"/}" ;;
    *) __rel="external/${__dest#/}" ;;
  esac

  mkdir -p "$__root/$(dirname "$__rel")"
  __backup="$__root/$__rel"
  # Two modules adopting the same path in one run must not clobber each other.
  if [ -e "$__backup" ] || [ -L "$__backup" ]; then
    __backup="$__backup.$$"
  fi

  mv "$__dest" "$__backup"
  printf 'adopt\t%s\t%s\n' "$__dest" "$__backup" >>"$__root/manifest.tsv"
  printf 'backed up: %s -> %s\n' "$__dest" "$__backup"
}

link_apply() {
  __kind="$1"
  __src="$2"
  __dest="$3"

  __rc=0
  link_check "$__kind" "$__src" "$__dest" || __rc=$?
  case "$__rc" in
    2) exit 2 ;;
    1)
      if [ "$LINK_ADOPT" != "1" ]; then
        link_conflict "$__dest" "$__src"
        exit 1
      fi
      link_backup "$__dest"
      ;;
  esac

  if [ -L "$__dest" ]; then
    __actual="$(link_target_path "$(readlink "$__dest")" "$__dest")"
    if [ -e "$__dest" ] &&
      [ "$(link_normalize "$__actual")" = "$(link_normalize "$__src")" ]; then
      return 0
    fi
    rm -f "$__dest"
    ln -s "$__src" "$__dest"
    printf 'repaired: %s -> %s\n' "$__dest" "$__src"
    return 0
  fi

  mkdir -p "$(dirname "$__dest")"
  ln -s "$__src" "$__dest"
  printf 'linked: %s -> %s\n' "$__dest" "$__src"
}

link_preflight() {
  __kind="$1"
  __src="$2"
  __dest="$3"

  __rc=0
  link_check "$__kind" "$__src" "$__dest" || __rc=$?
  case "$__rc" in
    2) exit 2 ;;
    1)
      if [ "$LINK_ADOPT" = "1" ]; then
        return 0
      fi
      link_conflict "$__dest" "$__src"
      exit 1
      ;;
  esac
}

link_main() {
  while [ $# -gt 0 ]; do
    case "$1" in
      --adopt)
        LINK_ADOPT=1
        shift
        ;;
      -h | --help | help)
        link_usage
        exit 0
        ;;
      *) break ;;
    esac
  done

  [ $# -eq 3 ] || link_die_usage "expected a command and two paths"

  __command="$1"
  __src="$2"
  __dest="$3"

  is_absolute "$__src" || link_fatal "source path must be absolute: $__src"
  is_absolute "$__dest" || link_fatal "destination path must be absolute: $__dest"

  case "$__command" in
    link_dir) link_apply dir "$__src" "$__dest" ;;
    link_file) link_apply file "$__src" "$__dest" ;;
    preflight_dir) link_preflight dir "$__src" "$__dest" ;;
    preflight_file) link_preflight file "$__src" "$__dest" ;;
    *) link_die_usage "unknown command: $__command" ;;
  esac
}

link_main "$@"
