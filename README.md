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

Tools that must not land in the shared config or the Docker image are provisioned per-machine by their module instead: the module writes a fragment to `~/.config/mise/conf.d/<module>.toml`, which mise merges automatically. The `opencode` module works this way so the k8s sidecar image stays agent-free.

```toml
[tools]
go        = "1.26"
node      = "24"
kubectl   = "1.35.3"
helm      = "4.1.3"
terraform = "1.14.8"
rust      = "stable"
"aqua:docker/cli" = "latest"
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
| `tmux/` | tmux config, TPM plugins |
| `git/` | Git config, aliases, delta pager |
| `fzf/` | fzf config and shell integration |
| `alacritty/` | Alacritty terminal config |
| `golang/` | Go environment variables |
| `kubernetes/` | kubectl aliases + completions (binary: mise) |
| `helm/` | Helm config + completions (binary: mise) |
| `terraform/` | Terraform config (binary: mise) |
| `docker/` | Docker aliases — `rd-docker` for Rancher's client (binary: mise `docker-cli`) |
| `bat/` | bat (better cat) config |
| `ripgrep/` | ripgrep config |
| `psql/` | psql config |
| `fonts/` | Powerline + Nerd Font (JetBrains Mono) |
| `rust/` | Rust toolchain + stylua (managed by mise) |
| `bin/` | Personal scripts |
| `opencode/` | opencode global config (binary provisioned per-machine via mise) |

Each module symlinks its config files into the appropriate XDG directory (`~/.config`, `~/.local/share`, etc). Modules are independent — install only what you need. Tool binaries are *not* installed by modules; everything comes from `mise.toml`, so Kubectl, Helm, Docker, and Rust work identically on Linux and macOS (Apple Silicon).

### Rancher Desktop

Rancher Desktop ships its own `kubectl`, `helm`, and `docker` in `~/.rd/bin`. Generic versions are still managed by mise so they work on any machine (bare servers, containers). mise shims come first on PATH, so plain `kubectl` is the generic client — use the `rd-*` aliases to target Rancher's cluster:

```bash
rd-kubectl
rd-helm
rd-docker
```

### Local overrides

Some files are intentionally not tracked in git. Create these locally as needed:

| File | Purpose |
|---|---|
| `modules.local.mk` | Add extra modules: `LOCAL_MODULES = terraform` |
| `git/config.local` | Per-machine git identity + auth per environment (copy from `git/config.local.example`) |
| `zsh/local` | Local env vars, tokens, secrets |

## Makefile commands

| Target | Description |
|---|---|
| `make all` | Install all modules |
| `make clean.all` | Remove all installed modules |
| `make [module]` | Install a specific module, e.g. `make nvim` |
| `make [module].clean` | Clean a specific module, e.g. `make nvim.clean` |
| `make help` | List all available targets |

There are currently no optional modules. To add one later, list it in `OPTIONAL_MODULES` in the root `Makefile` — it becomes installable via `make <module>` but stays out of `make all` (and out of the Docker image). Or append it to `LOCAL_MODULES` in `modules.local.mk` to include it in `make all` on that machine.

## Docker image

A pre-built multi-arch image (`linux/amd64`, `linux/arm64`) is published to [ghcr.io/kwtucker/dotfiles-devenv](https://ghcr.io/kwtucker/dotfiles-devenv) via GitHub Actions whenever `Dockerfile`, `mise.toml`, or the dotfiles themselves change. It includes all tools from `mise.toml` baked in so container startup is fast.

The image is used automatically by DevPod via `.devcontainer/devcontainer.json`.

## Debugging Kubernetes pods

The image doubles as an ephemeral debug sidecar — your shell, tools, and nvim, inside any pod:

```bash
kdebug   # fuzzy-select pod + container, attach with the devenv image
```

`kdebug` auto-mounts the pod's projected serviceaccount token, so `kubectl` works inside without copying credentials (the token carries the pod's own permissions). Override the image with `DEVENV_IMAGE=... kdebug`.

What you get and what you don't:

- **Shared with the target:** filesystem and network namespace. Read the app's files, `curl` its ports, run your tools against them.
- **Not shared:** processes. Seeing app PIDs needs `shareProcessNamespace: true` set on the workload at creation — it cannot be added to running pods.
- **Sessions:** the debug container is EOL'd when you detach; run `tm` (tmux) inside first and re-attach later if you get disconnected.
- **Prerequisites:** RBAC for `pods/ephemeral` on your user; the image must be pullable from the cluster (public ghcr or `imagePullSecrets`); `kubectl debug` needs a cluster recent enough for ephemeral containers (1.25+ stable-ish, 1.27+ solid).

Full workspaces instead of quick sessions: use the DevPod Kubernetes provider with this image — the dotfiles `install` lays symlinks via `make all` on top of the pre-warmed tools.
