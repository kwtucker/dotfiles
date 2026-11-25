# .Files

Modular, XDG-aware dotfiles for macOS and Linux: Zsh, Neovim, tmux, Git,
terminal applications, and development tools. Configuration lives in this
checkout; mise manages the shared tool catalog and platform lockfile.

## Start here

- **New machine:** follow the [first-install tutorial](docs/tutorials/first-install.md).
- **Existing machine:** [update your dotfiles](docs/how-to/update-dotfiles.md).
- **Different tool set:** [choose a profile](docs/how-to/switch-profiles.md).
- **Existing configuration:** [resolve conflicts and recover backups](docs/how-to/recover-configuration.md).

Installation is a state-changing operation, not a diagnostic: `./install` can
pull commits, install and prune tools, relink configuration, clean dropped
modules, and recycle an outdated tmux server. Read the
[safety boundaries](docs/explanation/safety-and-reproducibility.md) first.

## Documentation

The [documentation index](docs/README.md) is organized around four reader needs:

| Need | Start with |
| --- | --- |
| Learn through a guided exercise | [Tutorials](docs/README.md#tutorials) |
| Accomplish a specific task | [How-to guides](docs/README.md#how-to-guides) |
| Look up commands, paths, or settings | [Reference](docs/README.md#reference) |
| Understand the design and tradeoffs | [Explanation](docs/README.md#explanation) |

## Modules

Every directory with a module `Makefile` is available as `make <module>`.
[Profiles](docs/reference/profiles-and-tools.md) determine the default selection;
`copilot` and `cosmic` are opt-in. Module READMEs document their own prerequisites,
tasks, configuration, and cleanup effects.

| Module | Purpose |
| --- | --- |
| [agents](agents/README.md) | Shared engineering instructions and portable skills |
| [alacritty](alacritty/README.md) | Alacritty terminal configuration |
| [bat](bat/README.md) | Bat theme and output preferences |
| [bin](bin/README.md) | Portable helper scripts, including `gpg-key` |
| [copilot](copilot/README.md) | Optional Copilot CLI configuration and MCP servers |
| [cosmic](cosmic/README.md) | Optional COSMIC terminal scheme and desktop theme sources |
| [docker](docker/README.md) | Docker client aliases and completions |
| [fonts](fonts/README.md) | Powerline and JetBrains Mono Nerd Font files |
| [fzf](fzf/README.md) | Fuzzy selection, shell widgets, and `fzf-tmux` |
| [git](git/README.md) | Git identity routing, aliases, worktrees, and GPG setup |
| [golang](golang/README.md) | Go environment and shared Go tools |
| [helm](helm/README.md) | Helm completions and Rancher Desktop alias |
| [kubernetes](kubernetes/README.md) | kubectl aliases, selection, and debugging helpers |
| [nvim](nvim/README.md) | LazyVim, language tooling, diff review, and ACP chat |
| [opencode](opencode/README.md) | OpenCode V2 server and terminal configuration |
| [psql](psql/README.md) | PostgreSQL client preferences and paths |
| [ripgrep](ripgrep/README.md) | Search defaults and completions |
| [rust](rust/README.md) | Rust environment and completions |
| [sops](sops/README.md) | Structured-file encryption using an encrypted age identity |
| [terraform](terraform/README.md) | Terraform cache, aliases, and completions |
| [tig](tig/README.md) | Tig Git browser preferences |
| [tmux](tmux/README.md) | Sessions, panes, terminal bindings, and TPM plugins |
| [whalebyte](whalebyte/README.md) | Personal workspace and encrypted `wbs` vault |
| [zsh](zsh/README.md) | Shell startup, environment, plugins, and prompt |

## Inspect without installing

From the checkout root:

```sh
make profile.show
make tools.list
make status
make doctor
```

These checks are read-only and offline by default. See the
[command reference](docs/reference/commands.md) for network-enabled and
state-changing alternatives.

For repository maintenance, see [contributing a module](docs/how-to/add-module.md)
and the repository [agent guide](AGENTS.md). Agent instructions and vendored
skill definitions are operational files, not documentation to reorganize.
