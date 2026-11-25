# Git module reference

## Files and commands

| Item | Purpose / effect |
| --- | --- |
| `config` | Shared Git defaults, includes, aliases, push URL rewrite |
| `config.local.example` | Template for ignored default/per-directory identities and auth |
| `config.github` | Optional ignored GitHub-remote identity override |
| `make git` | Config, GPG agent setup, missing `wt` download, and completion |
| `make git.upgrade` | Fetch pinned `wt` again and refresh completion |
| `make -C git gpg-install` | Generate/link only the agent config when the Pinentry shim exists |
| `make -C git gpg-clean` | Remove only the generated agent-config link |
| `make git.clean` | Shared config/cache cleanup, generated agent link, `wt`, and `_wt` completion |

The `wt` artifact pin and SHA-256 live in [Makefile](Makefile). Its own
`wt version` command can self-update; do not treat it as a read-only version
probe or use it to bypass the tracked pin.

Tool ownership includes LazyGit, GitHub CLI, GnuPG, and Pinentry; see
[tools.mk](../tools.mk). Git itself must be provided by the host.

## Aliases and defaults

Inspect [config](config) for exact definitions. `st` shows short status; `br`
lists branches; `co` switches checkouts; `cb` fuzzy-selects a branch through fzf.
`pt` fetches and prunes refs/tags. `cm` stages all changes then commits; `wip`
can amend; `amend` changes the last commit. These are mutating conveniences,
not safety or Conventional Commit enforcement.

The default initial branch is `main`. Fetch/tag pruning is enabled. The merge
tool command expects VS Code's `code` executable, not installed by this module.
There is no configured delta pager in the current shared file.

## GPG paths

| Path | Meaning |
| --- | --- |
| `${GNUPGHOME:-$HOME/.gnupg}` | Real GPG home; remains local |
| `git/gpg-agent.conf.in` | Tracked agent template |
| `scripts/lib/gpg.sh` | Tracked generation/link helper |
| `git/gpg-agent.generated.conf` | Ignored output regenerated during installation |
| `$GNUPGHOME/gpg-agent.conf` | Managed link to generated output (default home above) |
| `$MISE_DATA_DIR/shims/pinentry-tty` | Stable prompt shim; default mise data is `~/.local/share/mise` |
| `git/gpg-agent.local.conf` | Earlier local-only setup file; no longer the managed generator output |

Missing Pinentry shim means setup is skipped with instructions. Existing
unmanaged config is refused unless adoption is enabled. Adoption backs up the
old file before linking; custom settings are not merged automatically.
Generated output is not a place for permanent personal edits.

Cleanup leaves the GPG home, private keys, and other GPG files untouched. Shared
module cleanup can remove its separate XDG cache; agent/key state is not that
module cache. For `gpg-key` command behavior, see the [bin reference](../bin/README.md#reference).
