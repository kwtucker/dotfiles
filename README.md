# .Files

> Modular, portable, XDG-compliant dotfiles for Zsh, Neovim, tmux, Git, and developer tools.
> Works on any Linux environment — local machines, remote servers, and ephemeral containers.

## Environments

These dotfiles are designed to work identically across all of the following:

**Local Linux machine** — full install with mise managing all tools.

**DevPod / ephemeral containers** — a pre-built Docker image ([ghcr.io/kwtucker/dotfiles-devenv](https://ghcr.io/kwtucker/dotfiles-devenv)) has all tools baked in. The install script detects this and only lays symlinks, making cold starts fast.

**Bare remote servers (SSH)** — no Docker required. One command installs mise and bootstraps the full environment from scratch.

**Shared company servers** — mise installs everything into `~/.local` with no root access required. Other users on the same machine are unaffected.

**Chromebook or any thin client** — SSH in from a browser-based terminal or any SSH client. The computer you're working from doesn't matter.

## Quick Start

### Local machine or bare server

```bash
git clone git@github.com:kwtucker/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

### DevPod

```bash
devpod up . --provider docker \
  --dotfiles git@github.com:kwtucker/dotfiles.git
```

The `devcontainer.json` in this repo points DevPod at the pre-built image automatically.

## How it works

### Tools — mise

All CLI tools and language runtimes are declared in [`mise.toml`](./mise.toml) and managed by [mise](https://mise.jdx.dev). This replaces Nix, asdf, nvm, and any other version managers with a single file.

```toml
[tools]
go        = "1.26.1"
node      = "22.9.0"
kubectl   = "1.30.3"
helm      = "3.19.0"
terraform = "1.9.5"
"aqua:neovim/neovim" = "latest"
# ...and more
```

To update a tool, change the version in `mise.toml` and push. CI rebuilds the Docker image automatically.

Per-project overrides are supported — drop a `mise.toml` in any project directory and mise will switch tool versions automatically when you `cd` into it.

### Dotfiles — Make modules

Configuration is split into independent modules, each in its own directory with a `Makefile`. The root `Makefile` coordinates them all.

| Module | What it configures |
|---|---|
| `zsh/` | Zsh config, env, path, aliases, antigen plugins |
| `nvim/` | Neovim / LazyVim config |
| `tmux/` | tmux config |
| `git/` | Git config, aliases, delta pager |
| `fzf/` | fzf config and shell integration |
| `alacritty/` | Alacritty terminal config |
| `golang/` | Go environment variables |
| `kubernetes/` | kubectl aliases and config |
| `helm/` | Helm config |
| `terraform/` | Terraform config |
| `docker/` | Docker config |
| `bat/` | bat (better cat) config |
| `ripgrep/` | ripgrep config |
| `psql/` | psql config |
| `bin/` | Personal scripts |

Each module symlinks its config files into the appropriate XDG directory (`~/.config`, `~/.local/share`, etc). Modules are independent — install only what you need.

### Local overrides

Some files are intentionally not tracked in git. Create these locally as needed:

| File | Purpose |
|---|---|
| `modules.local.mk` | Add extra modules: `LOCAL_MODULES = terraform` |
| `git/config.local` | Git user name, email, and URL remaps |
| `zsh/local` | Local env vars, tokens, secrets |

## Makefile commands

| Target | Description |
|---|---|
| `make all` | Install all modules |
| `make clean.all` | Remove all installed modules |
| `make [module]` | Install a specific module, e.g. `make nvim` |
| `make [module].clean` | Clean a specific module, e.g. `make nvim.clean` |
| `make help` | List all available targets |

## Docker image

A pre-built image is published to [ghcr.io/kwtucker/dotfiles-devenv](https://ghcr.io/kwtucker/dotfiles-devenv) via GitHub Actions whenever `Dockerfile` or `mise.toml` changes. It includes all tools from `mise.toml` baked in so container startup is fast.

The image is used automatically by DevPod via `.devcontainer/devcontainer.json`.

## Credits

Influenced by and examples taken from [mnarrell/dotfiles](https://github.com/mnarrell/dotfiles).
