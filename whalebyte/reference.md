# Vault reference

## Commands

| Command | Effect |
| --- | --- |
| `wbs` / `wbs edit` | Decrypt, edit, validate, re-encrypt; writes only when content changes |
| `wbs init` | Create a protected identity, public recipient, and new empty vault; refuse existing vault/identity |
| `wbs rekey` | Convert legacy age-passphrase JSON to keypair layout; not routine key rotation |
| `wbs get KEY` | Decrypt and print one value to stdout |
| `wbs list` / `wbs keys` | Decrypt and list key names |
| `wbs validate` / `wbs check` | Decrypt and validate JSON; report count |
| `wbs export KEY` | Zsh wrapper: export one environment variable without printing its value |
| `wbs help` | Show usage and selected paths |

Executable failures generally exit `1`; external command statuses can propagate.
The Zsh export wrapper returns `2` for bad usage and otherwise the retrieval
status, preserving the previous variable on failure.

## Paths and overrides

| Item | Selection |
| --- | --- |
| Workspace/vault directory | `$WHALEBYTE`, default `~/.whalebyte` |
| Vault | `$WHALEBYTE/.secret` |
| Identity | `$WBS_IDENTITY`, else existing `$XDG_CONFIG_HOME/age/wbs-identity.age`, else `$WHALEBYTE/.age-identity` |
| Recipient | `$WBS_RECIPIENT`, else existing `$XDG_CONFIG_HOME/age/wbs-recipient`, else `$WHALEBYTE/.age-recipient` |
| Editor | `$WBS_EDITOR`, else `$VISUAL`, else `$EDITOR`, else `nvim` |
| Temporary data | Private `$WHALEBYTE/.wbs.XXXXXX` directory during operations |
| Shell wrapper | `$XDG_CONFIG_HOME/whalebyte/function.zsh` |

The tracked shell env sets `WHALEBYTE` to `~/.whalebyte`; override afterward in
ignored `zsh/local` if needed. Identity and recipient defaults are chosen
independently by file presence; inspect both paths before changing layout.
Vault/identity files are written as `0600`, recipient as `0644`, and temporary
directory as `0700`.

The editor invocation expects a Neovim-compatible executable and disables
swap/backup/undo/shada persistence for the decrypted file. `WBS_EDITOR` is an
executable selection, not an arbitrary shell command string.

See [bin/wbs](bin/wbs) and [function.zsh](function.zsh) for the actual contract.
Shared `temp-ssh-key`/`vpn` tools are not vault subcommands; their source and
account configuration are maintained separately.
