# Zsh

Shell startup, environment, PATH, aliases/functions, Antigen plugins, and the
Starship prompt. This module does not change your login shell automatically.

## How-to apply and customize

Provision the selected tools and run `make zsh` from the dotfiles root. Open a
new Zsh session when ready: startup sources module files and can attach to
tmux, so do not source the complete `.zshrc` merely to validate syntax.

Put machine-specific overrides in ignored `zsh/local`. Use a small environment
export in the current terminal when you only need that setting immediately.
`make zsh.upgrade` updates Antigen/plugins and regenerates caches; it accesses
the network and changes state.

## Reference

- Config link: `$XDG_CONFIG_HOME/zsh`; `~/.zshenv` links [zshenv](zshenv).
- `ZDOTDIR`: `$XDG_CONFIG_HOME/zsh`, so the installed shell does not read the
  ordinary `~/.zshrc`.
- [env.zsh](env.zsh): history, editor, and Starship config.
- [path.zsh](path.zsh): explicit PATH construction, including HOME-based mise
  shims and platform/legacy directories; custom inherited PATH additions may
  need a local override.
- [.zshrc](.zshrc): env files first, completions/plugins, other module files,
  local overrides, and automatic `main` tmux attachment.
- `GPG_TTY`: set for interactive shells with a terminal.
- Completion directory: `$XDG_DATA_HOME/zsh/completions`.
- `make zsh.clean`: shared config/cache cleanup, owned `.zshenv`, selected
  generated completions, and empty completion/data directories. Shell history
  in the data directory is not explicitly removed.

## Explanation

Mise shims resolve the selected installed binary when invoked. The shell does
not need hard-coded version directories under `mise/installs`; mise activation
can add those dynamically. The shim directory is already added by `path.zsh`.
A long-running editor/service can retain a removed version's inherited PATH
after an update. Start it from a fresh shell or use `mise exec -- nvim` to resolve
the current tool environment without editing PATH to a specific version.

Profiles decide which modules are installed, not which shell files load for a
particular terminal. All installed module Zsh files can be sourced; local files
can override earlier defaults. Other shells and already-running applications
do not inherit new exports automatically. Keep credentials out of tracked
files and remember that exported secrets remain in child-process environments.
