# wbs export KEY — load one vault secret into the current shell.
#
# `bin/wbs` is a standalone executable and cannot modify its parent shell, so
# this wrapper intercepts only `wbs export KEY`. Every other subcommand passes
# straight through. The value is exported, never printed or `eval`ed.
#
# Usage:   wbs export KEY
# Returns: 0 on success, 2 for bad usage, otherwise the exit status of
#          `wbs get` (the variable is left unchanged on failure).
function wbs() {
  emulate -L zsh
  unsetopt xtrace verbose

  if [[ ${1-} != export ]]; then
    command wbs "$@"
    return $?
  fi

  if (( $# != 2 )) || [[ ! $2 =~ '^[A-Za-z_][A-Za-z0-9_]*$' ]]; then
    print -u2 -r -- 'usage: wbs export KEY (KEY must be an environment variable name)'
    return 2
  fi

  # Reuse the positional parameters instead of scratch variables: a scratch
  # variable named after KEY would shadow the global this function must create.
  argv=("$2" "$(command wbs get "$2")") || return $?
  typeset -gx -- "$1=$2"
}
