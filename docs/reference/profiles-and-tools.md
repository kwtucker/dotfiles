# Profiles and tool ownership

The authoritative module sets are in [profiles.mk](../../profiles.mk), tool
versions in [mise.toml](../../mise.toml), and ownership in [tools.mk](../../tools.mk).

## Profiles

| Profile | Modules |
| --- | --- |
| `minimal` | `bin zsh tmux git tig fzf nvim agents opencode` |
| `dev` | `minimal` plus `golang bat ripgrep rust docker` |
| `infra` | `dev` plus `kubernetes helm terraform psql sops whalebyte` |
| `workstation` | `dev` plus `alacritty fonts` |
| `full` | Union of `infra` and `workstation`; default |

`copilot` and `cosmic` are available but not in the tracked profiles.
OpenCode is Neovim's default ACP backend and is included in every standard
profile. Copilot remains an explicitly installed/selected override.
`LOCAL_MODULES` adds modules without changing the chosen profile. Every
directory with a module Makefile is available as a root Make target.

Selection precedence, highest first:

1. `PROFILE=NAME` supplied to Make (or propagated through installation).
2. `DOTFILES_PROFILE` environment variable.
3. Ignored `profile.local` in the checkout.
4. `full`.

Unknown profile names are errors. Use `make profile.show` and `make tools.list`
to inspect resolution without applying it.

## Tool sets

| Set | Selection / cleanup behavior |
| --- | --- |
| Base | Make, ShellCheck, shfmt; included everywhere, not removed by profile cleanup |
| Explicit shared | Personal CLIs declared in `SHARED_TOOLS`; included everywhere, not removed by profile cleanup |
| Module-owned | Included when the owning module is selected; eligible for profile cleanup |
| Profile extras | Included for the selected profile; eligible for profile cleanup |
| Unclassified | Included as shared, never auto-removed by profile cleanup; warned about by `make tools.check` |
| Machine-local declarations | Protected from the installer's profile-tool removal |

A tool with multiple owners remains selected while any active owner needs it.
The final mise prune operation is separate from profile removal and can remove
superseded versions. `DOTFILES_KEEP_TOOLS=1` skips profile tool removal, not all
other cleanup.

`MODULES=...` overrides Make's resolved module list for a command. For example,
`make tools.list MODULES=copilot` still includes base/shared tools and the
active profile's extras; it is not strictly a single-tool query.

## Version policy

CLI tools generally use exact pins. Go, Node, Python, and Make use ranges;
Rust uses `stable`. `minimum_release_age` delays newly released fuzzy matches,
but not exact pins or matching locked versions. Rust's moving channel needs a
project `rust-toolchain.toml` for stronger compiler reproducibility.

[mise.lock](../../mise.lock) records resolved versions and per-platform download
metadata for Linux/macOS x64/ARM64. Backend capabilities differ: do not assume
every artifact has an upstream checksum or an identical dependency graph.
New platform lock resolution is not a live test on that platform.

See [updating pins](../how-to/update-dotfiles.md#update-tool-pins-deliberately)
and [reproducibility limits](../explanation/safety-and-reproducibility.md).
