# Environment and local overrides

Paths below are defaults. Some application helpers still hard-code HOME-based
paths; a custom XDG setting does not prove every application honors it.

## Shared paths

| Variable / location | Default or purpose |
| --- | --- |
| `HOME` | Current user's home; module recipes use it for user-local paths |
| `XDG_CONFIG_HOME` | `$HOME/.config` |
| `XDG_CACHE_HOME` | `$HOME/.cache` |
| `XDG_DATA_HOME` | `$HOME/.local/share` |
| `XDG_STATE_HOME` | `$HOME/.local/state` |
| `DOTFILES_ROOT` | Script checkout root; normally inferred from the script |
| `DOTFILES_STATE_DIR` | Make default `$XDG_STATE_HOME/dotfiles`; scripts derive it from XDG state |
| `ZSH_COMPLETIONS_DIR` | `$XDG_DATA_HOME/zsh/completions`; Make recomputes it, ignoring inherited shell values |
| `MISE_DATA_DIR` | Helpers default to `$HOME/.local/share/mise` |
| `COPILOT_HOME` | `$HOME/.copilot` |
| `GNUPGHOME` | GPG setup defaults to `$HOME/.gnupg` |
| `FONT_DIR` | `$HOME/Library/Fonts` on macOS; `$XDG_DATA_HOME/fonts` on Linux |

Override Make-derived completion paths explicitly with
`ZSH_COMPLETIONS_DIR=/path` on the Make command line when needed.

## Installation controls

| Variable | Effect |
| --- | --- |
| `PROFILE`, `DOTFILES_PROFILE` | Profile selection; see [precedence](profiles-and-tools.md) |
| `FORCE=1` | Bypass module-pass fast path |
| `DOTFILES_ADOPT=1` | Back up conflicting module link destinations before replacement |
| `DOTFILES_BACKUP_ROOT`, `DOTFILES_BACKUP_ID` | Override adoption backup parent/run name |
| `DOTFILES_SKIP_FONTS=1` | Skip downloads; write a marker when fonts are not already present |
| `DOTFILES_SKIP_FONTS=0` | Override automatic container font skipping |
| `DOTFILES_KEEP_TOOLS=1` | Keep tools dropped by a profile change; module cleanup still runs |
| `DOTFILES_PROFILE_CLEANUP=1` | Internal marker for removed-module cleanup |
| `FETCH_MAX_BYTES` | Verified downloader size limit; default 256 MiB |
| `MISE_BOOTSTRAP_VERSION`, `MISE_BOOTSTRAP_DEST` | Bootstrap release/destination overrides; inspect checksum implications before overriding |

## Ignored local configuration

| File | Purpose |
| --- | --- |
| `profile.local` | Persistent selection for this checkout/machine |
| `modules.local.mk` | Additive `LOCAL_MODULES` |
| `mise.local.toml` | Local tool/config overrides scoped to this checkout |
| `~/.config/mise/config.local.toml` | Machine-wide local mise declarations |
| `git/config.local`, `git/config.env-*` | Default and per-directory Git identities/auth settings |
| `git/config.github` | GitHub-remote identity override |
| `git/gpg-agent.generated.conf*` | Generated machine path for the managed agent config |
| `git/gpg-agent.local.conf` | Earlier local-only agent config; not used by the current generator |
| `zsh/local` | Machine-specific shell overrides; can contain secrets |
| `~/.tmux.conf.local` | User tmux override outside the checkout |
| `copilot/mcp-config.local.json` | Ignored legacy config; no longer installed or read by this module |

Application-specific variables are documented in their module references:
[Neovim](../../nvim/reference.md), [Git/GPG](../../git/reference.md), and
[vault](../../whalebyte/reference.md). Never publish credentials, session data,
or raw local override contents in troubleshooting output.
