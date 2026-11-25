# tmux

Terminal sessions, pane/window bindings, Catppuccin status styling, and TPM
plugins. Mise owns the tmux binary; the module separately pins TPM by tag and
commit.

## How-to install and enter a session

Provision the tools and run `make tmux` from the dotfiles root. Installation can
clone/pin TPM and install plugins when a server is running. The config can also
bootstrap plugins on startup; neither operation is a read-only check.

Zsh automatically attaches to `main` outside tmux. Use `tm SESSION` to select
or create a named session, or `tm` for fuzzy selection. **Outside tmux, `tm`
can kill a server whose version differs from the client**, ending its sessions.
Save work first when updating binaries.

## How-to refresh configuration or plugins

`make tmux.upgrade` deliberately updates plugins and refreshes repository tags;
it keeps TPM itself at the declared pin. Prefix+r also updates plugins before
reloading config; it is not a reload-only binding.

`tmux source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"` reloads configuration, but
the file's plugin startup commands can still install missing plugins. Inspect
sessions with `tmux list-sessions` before any lifecycle/removal action.

## Reference

- Config link: `$XDG_CONFIG_HOME/tmux`.
- Prefix: Control-Space, with Control-b unbound; see [prefix.conf](prefix.conf).
- Terminal type: `screen-256color`; default shell uses `$SHELL`.
- TPM/plugins: `~/.tmux/plugins`; TPM pin in [Makefile](Makefile).
- Local override: `~/.tmux.conf.local`, outside this checkout.
- [function.zsh](function.zsh): `tm` and destructive selected-session removal
  through `tmk`.
- `make tmux.clean`: owned config/module cache and TPM directory removal when
  its Git origin matches the expected TPM repository. Other plugin directories
  are not explicitly removed by this target; running sessions are not stopped.

## Explanation

The binary, server process, TPM, and plugins have independent lifecycles.
Replacing a binary does not update an existing server. Terminal prompt problems
can also involve stale GPG terminal state; see the
[GPG prompt guide](../git/how-to.md#repair-a-passphrase-prompt).
