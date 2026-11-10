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

### Updating an existing machine

`./install` is idempotent. Run it again — or `make update`, which wraps it — on
a machine that is already set up and it becomes an **update**: it pulls the
latest dotfiles (`git pull --ff-only`), installs any tools or modules another
machine added, re-links all configs, and prunes superseded tool versions.

```bash
cd ~/.dotfiles
./install          # or: make update  (or: make install)
```

When the checkout is unchanged since the last successful run, the module pass is
skipped automatically (tools are still topped up). Force a full pass with
`FORCE=1 ./install`.

## How it works

### Tools — mise

All CLI tools and language runtimes are declared in [`mise.toml`](./mise.toml) and managed by [mise](https://mise.jdx.dev). This replaces Nix, asdf, nvm, and any other version managers with a single file.

OpenCode and Copilot CLI are declared here too. The Copilot Desktop app is
installed separately; its MCP servers and skills can reuse the CLI configuration.

```toml
[tools]
go        = "1.26"       # minor range — patch releases flow
node      = "24"
kubectl   = "1.35.3"     # exact pin — bumps are deliberate
helm      = "4.1.3"
terraform = "1.14.8"
rust      = "stable"
tmux      = "3.7c"
"aqua:docker/cli"    = "29.9.0"
"aqua:neovim/neovim" = "0.12.6"
# ...and more
```

GNU Make is managed here too: macOS ships Make 3.81, which lacks `--output-sync`,
so `mise.toml` pins a modern GNU Make (4.x) and the parallel module pass runs the
same way on Linux and macOS.

**Versioning policy.** CLI tools and LSP servers are pinned to exact versions,
so upgrading one is a deliberate, reviewable commit; language runtimes (`go`,
`node`, `python`, `make`) keep their minor range so patch releases flow. To bump
a tool: `make outdated` to preview → edit the pin here → commit/push → on a live
machine run `./install` (or `mise install`). `make upgrade.tools` will not move
exact pins, and `make prune.tools` cleans up superseded versions.

Long-running processes keep the old binary until they restart, so `./install`
recycles the tmux server automatically when its version changes (skipped when run
from inside tmux). Editors are not touched — restart Neovim after changing its
version, or restart affected LSP clients after changing a server binary.

One exception worth knowing: `rust` is a rustup-managed `stable` channel
(`~/.local/share/mise/installs/rust/stable` → `~/.cargo/bin`), so it is *not*
reproducible from this file — pin it with rustup (a `rust-toolchain.toml`) if
that matters.

Per-project overrides are supported — drop a `mise.toml` in any project directory and mise will switch tool versions automatically when you `cd` into it.

### Dotfiles — Make modules

Configuration is split into independent modules, each in its own directory with a `Makefile`. The root `Makefile` coordinates them all.

| Module | What it configures |
|---|---|
| `zsh/` | Zsh config, env, path, aliases, antigen plugins |
| `nvim/` | Neovim / LazyVim config |
| `tmux/` | tmux config, TPM plugins |
| `git/` | Git config, aliases, delta pager |
| `tig/` | Tig Git browser config (binary: mise) |
| `fzf/` | fzf config and shell integration |
| `alacritty/` | Alacritty terminal config |
| `golang/` | Go environment variables; `gofumpt`, `goimports`, `staticcheck`, `govulncheck` (binary: mise) |
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
| `agents/` | Shared AI instructions and skills |
| `opencode/` | OpenCode config, commands, and plugins (binary: mise) |
| `copilot/` | Optional Copilot CLI config and MCP servers (binary: mise) |

Each module symlinks its config files into the appropriate XDG directory (`~/.config`, `~/.local/share`, etc). Modules are independent — install only what you need. Tool binaries are *not* installed by modules; everything comes from `mise.toml`, so Kubectl, Helm, Docker, and Rust work identically on Linux and macOS (Apple Silicon).

See [`nvim/README.md`](./nvim/README.md) for editor setup and maintenance.

### AI agent configuration

OpenCode and Copilot share [engineering instructions](./agents/instructions/engineering.md)
and [skills](./agents/skills/) from `agents/`. Client-specific settings and MCP
definitions stay in `opencode/` and `copilot/`; project guidance stays in each repo.

```bash
make agents                # Install shared instructions and skills
make opencode              # Install shared files and OpenCode config
make copilot               # Install shared files and Copilot config (optional)
make -C agents sync-skills  # Refresh the commit skill; review the diff
```

Use the root targets so shared files install before either client. Copilot config
links into `${COPILOT_HOME:-$HOME/.copilot}` without replacing personal instructions
or session data. Conflicting files must be merged and moved aside first; clean
targets for `agents` and `copilot` remove only links owned by this checkout.

- **Go:** the [`go-development` skill](./agents/skills/go-development/SKILL.md)
  provides the shared workflow; both clients use mise-managed `gopls mcp` for
  saved-file context and diagnostics.
- **Terse replies:** the opt-in [`caveman` skill](./agents/skills/caveman/SKILL.md)
  changes chat style only. See its [usage notes](./agents/skills/caveman/UPSTREAM.md)
  for activation and updates.
- **Copilot Desktop:** reuses CLI skills and MCP servers, but manages its own app
  preferences. Check discovery in **Customize → Skills/MCP** and ensure `gopls`
  is on the app's PATH.

Existing local skills are left untouched; review overlapping Go or commit skills
before migrating. See [`agents/EVALUATION.md`](./agents/EVALUATION.md) for discovery
and quality checks, and [`AGENTS.md`](./AGENTS.md) for repository guidance.

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

## Kubernetes debugging

Ephemeral Kubernetes troubleshooting containers live in
[kwtucker/k8s-debug](https://github.com/kwtucker/k8s-debug). It consumes this
repo's `nvim/` config at a pinned commit and sets `K8S_DEBUG=1`, which makes
`nvim/lua/plugins/mason.lua` skip Mason installs entirely.

## Makefile commands

| Target | Description |
|---|---|
| `make install` / `make update` | Install or update this machine (runs `./install`) |
| `make all` | Relink all modules in parallel (no pull, top-up, or prune) |
| `make clean.all` | Remove all installed modules |
| `make [module]` | Install a specific module, e.g. `make nvim` |
| `make [module].clean` | Clean a specific module, e.g. `make nvim.clean` |
| `make outdated` | Preview outdated tools for `mise.toml` (no changes) |
| `make upgrade.tools` | Upgrade mise tools within pinned ranges + refresh completions |
| `make prune.tools` | Remove superseded mise tool versions (keeps referenced ones) |
| `make upgrade.plugins` | Upgrade plugins with an `upgrade` target (`nvim`, `tmux`, `zsh`, `opencode`); skips the rest |
| `make upgrade.all` | `upgrade.tools` + `upgrade.plugins` (tools first) |
| `make [module].upgrade` | Upgrade a specific module's plugins, e.g. `make nvim.upgrade` |
| `make help` | List all available targets |

Upgrades are split by design: `upgrade.tools` never rewrites version pins
(`mise upgrade` stays within the ranges in `mise.toml`; bumps stay manual via
`make outdated` → edit → commit).

`copilot` is an optional module: install it with `make copilot`, or append it to
`LOCAL_MODULES` in `modules.local.mk` to include it in `make all` on that machine.
Additional optional modules can be listed in `OPTIONAL_MODULES` in the root
`Makefile`.
