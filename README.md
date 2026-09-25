# .Files

> Modular, portable, XDG-compliant dotfiles for Zsh, Neovim, tmux, Git, and developer tools.
> Works on any Linux environment — local machines and remote servers.

## Environments

These dotfiles are designed to work identically across all of the following:

**Local Linux machine** — full install with mise managing all tools.

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

## How it works

### Tools — mise

All CLI tools and language runtimes are declared in [`mise.toml`](./mise.toml) and managed by [mise](https://mise.jdx.dev). This replaces Nix, asdf, nvm, and any other version managers with a single file.

Tools that must stay machine-local instead of shared are provisioned per-machine by their module: the module writes a fragment to `~/.config/mise/conf.d/<module>.toml`, which mise merges automatically. The `opencode` module works this way.

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

To update a tool, change the version in `mise.toml`, commit, and push. On a live machine, run `mise install` to apply.

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

## Workspace image (`image/`)

Public `ghcr.io/kwtucker/workspace:latest` — a runnable export of these
dotfiles for remote Go development and Kubernetes debugging. No logins
anywhere: public repo + public image, zero `imagePullSecrets`.

### Design decisions

| Decision | Rationale |
|---|---|
| Ubuntu 24.04, `USER dev` (uid 1000) + passwordless sudo | mise aqua backends + LazyVim need glibc; non-root passes restricted PSS. Override to root per-session (`sudo -i`, `runAsUser: 0`) only when debugging demands it |
| Slim toolset (`image/mise.workspace.toml`), versions pinned | Full `mise.toml` would be 2–4 GB. Pins keep builds reproducible and dodge anonymous `api.github.com` rate limits on shared runners |
| Go + `gopls` included, fonts excluded | Go is daily-driver; Nerd Fonts render in the *local* terminal emulator, never from container fontconfig |
| Antigen: `git-open` laptop-only, oh-my-zsh `git` plugin removed everywhere | `git-open` needs a browser; the framework clone was the slowest first-run cost. Gated by `WORKSPACE_IMAGE` in `zsh/.zshrc` so the laptop is untouched |
| Mason: 17-package Go/infra subset in containers, full 23 on laptops | `pyright`, `rust-analyzer`, `eslint`, etc. would download hundreds of MB per fresh container. Gated by `vim.env.WORKSPACE_IMAGE` in `nvim/lua/plugins/mason.lua` |
| Fetch GitHub over HTTPS, only push via SSH (`git/config`) | A global fetch rewrite (`insteadOf`) silently breaks every clone where no SSH keys exist (containers, CI). `pushInsteadOf` keeps laptop pushes on SSH unchanged |
| Starship untouched | `aws`/`kubernetes`/`docker`/`golang` modules already disabled; `terraform` only fires inside tf dirs |

### Layout

| Path | Purpose |
|---|---|
| `image/Dockerfile` | Build: explicit `COPY` list (secrets can't bake in), split `RUN` layers per failure domain, `SHELL bash` (mise activation is bash-only) |
| `image/mise.workspace.toml` | Pinned slim toolset. Refresh: `mise outdated` on laptop → bump → push |
| `image/entrypoint.sh` | `sleep infinity` by default; self-heals a missing `lazy.nvim` clone instead of `E5113` |
| `image/devcontainer.json` | Same image for DevPod / VS Code devcontainers |
| `image/k8s/dev-pod.yaml` | Deployment + PVC (`/home/dev/work`, Go caches persist), `runAsNonRoot: 1000`, no pull secrets |
| `image/k8s/debug-examples.sh` | Copy/paste recipes: standalone pod, workspace deploy, ephemeral debug, no-clone apply |
| `.github/workflows/workspace-image.yaml` | Builds `linux/amd64,arm64` on pushes touching `image/**` or baked modules; authenticates `api.github.com` via ephemeral `GITHUB_TOKEN` secret |

### Use

```bash
# Personal — build, run, deploy
docker run -it ghcr.io/kwtucker/workspace:latest zsh   # ~2s prompt, no downloads
kubectl apply -f image/k8s/dev-pod.yaml
kubectl exec -it deploy/workspace -- zsh

# Work (no GitHub login) — clone public, apply, go
git clone https://github.com/kwtucker/dotfiles.git ~/.dotfiles
kubectl -n <ns> apply -f image/k8s/dev-pod.yaml         # or the raw URL in debug-examples.sh

# Debug a failing pod (explicit profile; legacy default is deprecated)
kubectl debug -it pod/<x> --image=ghcr.io/kwtucker/workspace:latest \
  --profile=general --share-processes --target=<c> -- zsh

# Pick up a new release
kubectl rollout restart deploy/workspace
```

### Troubleshooting (all hit during bring-up)

| Symptom | Cause | Fix (already in tree) |
|---|---|---|
| `useradd ... exit code: 4` | Stock `ubuntu` user holds uid 1000 on 24.04 | `userdel` it first (Dockerfile) |
| Mega-`RUN` dies `exit code: 2` with no clue | `mise activate bash` emits bashisms; Docker uses dash | `SHELL bash` + one `RUN` per layer |
| `E5113: module 'lazy' not found` in container | `https://github.com/` rewritten to SSH by dotfiles gitconfig; keyless envs die at host-key prompt | `pushInsteadOf` (fetch stays HTTPS); entrypoint self-heal net; loud build-time clone |
| Only 5/18 mise tools installed, green build | Anonymous `api.github.com` rate-limited; aqua/github backends silently skipped | Pinned versions + `GITHUB_TOKEN` secret + shim sentinel that fails the layer loud |
| First `zsh` hangs cloning antigen bundles | Bundles cloned on first interactive shell, silently | `zsh -ic true` pre-warm layer |
| First `nvim` downloads ~23 Mason packages | `ensure_installed` installs lazily | Subset gate + `MasonInstall` with registry-poll wait (`+qa` alone aborts async installs) |
| `kubectl debug` → `Forbidden ... default serviceaccount` | Bare SA lacks `get pods` + `pods/ephemeralcontainers` | Admin context, or local-only `cluster-admin` binding (see debug-examples.sh; never on shared clusters) |
| `kubectl debug` warns about non-root pod | Our image runs as `dev` by design | `sudo -i` per command, or `--custom` profile with `runAsUser: 0` |

### Maintenance

* Bump a tool: `mise outdated` locally → edit the pin in `image/mise.workspace.toml` → push. If it's a Mason-covered tool, keep `nvim/lua/plugins/mason.lua` (source of truth) and the Dockerfile `MasonInstall` list in sync — a scripted check in CI prints both counts.
* After pushing, CI rebuilds (~10–40 min: full rebuilds + emulated arm64 leg are slow). Re-pull and verify: full `shims/` listing, ~2s prompt with no `Installing...` lines, clean `nvim` open, `:Mason` all installed.

## Makefile commands

| Target | Description |
|---|---|
| `make all` | Install all modules |
| `make clean.all` | Remove all installed modules |
| `make [module]` | Install a specific module, e.g. `make nvim` |
| `make [module].clean` | Clean a specific module, e.g. `make nvim.clean` |
| `make outdated` | Preview outdated tools for `mise.toml` + `image/mise.workspace.toml` (no changes) |
| `make upgrade.tools` | Upgrade mise tools within pinned ranges + refresh completions |
| `make upgrade.plugins` | Upgrade plugins with an `upgrade` target (`nvim`, `tmux`, `zsh`, `opencode`); skips the rest |
| `make upgrade.all` | `upgrade.tools` + `upgrade.plugins` (tools first) |
| `make [module].upgrade` | Upgrade a specific module's plugins, e.g. `make nvim.upgrade` |
| `make help` | List all available targets |

Upgrades are split by design: `upgrade.tools` never rewrites version pins
(`mise upgrade` stays within the ranges in `mise.toml`; bumps stay manual via
`make outdated` → edit → commit). The workspace image file is preview-only —
pushing a bump there triggers a CI rebuild (~10–40 min).

There are currently no optional modules. To add one later, list it in `OPTIONAL_MODULES` in the root `Makefile` — it becomes installable via `make <module>` but stays out of `make all`. Or append it to `LOCAL_MODULES` in `modules.local.mk` to include it in `make all` on that machine.
