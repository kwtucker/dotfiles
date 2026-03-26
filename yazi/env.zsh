#! /usr/bin/env zsh

# y — wrapper around yazi that changes the shell's working directory
# when you quit yazi. Use `y` instead of `yazi` to get this behaviour.
# Plain `yazi` still works without the cd-on-exit feature.
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  local cwd
  IFS= read -r -d '' cwd < "$tmp"
  if [[ -n "$cwd" && "$cwd" != "$PWD" && -d "$cwd" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
