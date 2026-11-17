# .Files

> Modular, portable, XDG-compliant dotfiles for Zsh, Neovim, tmux, Git, and developer tools.

One checkout per machine, applied with `./install`. Configuration is split into
independent Make modules; CLI tools and runtimes are pinned in
[`mise.toml`](./mise.toml) and installed by mise. No root access and no Nix/asdf
— everything lives under your home directory, so other users on a shared host are
unaffected.

Works on local Linux machines, bare SSH servers, thin clients, and headless
containers. Docker, Codespaces, and devcontainers skip the font download
automatically; see [Headless installs](#headless-installs).

## Quick start

### New machine

```bash
git clone git@github.com:kwtucker/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

`./install` bootstraps mise from a verified release archive, installs the active
profile's tools, links every selected module, and prunes superseded tool versions.
Re-running it is always safe.

### Existing machine

```bash
cd ~/.dotfiles
./install          # or: make update  (or: make install)
```

On an existing install it pulls with `--ff-only`, ensures the active tool set,
relinks modules, cleans what a profile switch dropped, and prunes.

The module pass is skipped when the applied-state stamp still matches the commit,
checkout path, XDG bases, ignored overrides, and selected profile/module/tool
sets, the worktree is clean, and `scripts/state check-links --quiet` verifies
every expected link. The active tool set is still ensured in that fast path.
`FORCE=1 ./install`
always re-applies. The stamp lives at
`${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/last-applied` (atomic v2
`key=value`); a failed or interrupted run never writes it, so the next run
retries.

### Headless installs

Docker (`/.dockerenv`), Codespaces (`CODESPACES`), and devcontainers
(`REMOTE_CONTAINERS`) export `DOTFILES_SKIP_FONTS=1`; the `fonts` module records
the omission in `${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/fonts-skipped`.
Override with `DOTFILES_SKIP_FONTS=0 ./install` when the container hosts a
terminal, or `DOTFILES_SKIP_FONTS=1 make fonts` to skip elsewhere. Only font files
are skipped.

## Profiles

A profile is an install-time choice of modules and tools. It is not a shell mode:
every installed module is available in every terminal.

| Profile | Includes |
|---|---|
| `minimal` | `bin zsh tmux git tig fzf nvim agents` |
| `dev` | `minimal` + `golang bat ripgrep rust docker opencode` |
| `infra` | `dev` + `kubernetes helm terraform psql sops whalebyte` |
| `workstation` | `dev` + `alacritty fonts` |
| `full` | `infra` + `workstation` (default); `copilot` stays opt-in |

Selection precedence, highest first:

1. `PROFILE=<name>` on the command line
2. `DOTFILES_PROFILE` in the environment
3. `profile.local` in the checkout (ignored, one profile name)
4. `full`

```bash
make profile.list                # profiles and the active one
make profile.show                # profile, modules, and tool count
make profile.set PROFILE=infra   # write profile.local
./install                        # apply it
make profile.clear               # remove profile.local (back to default)
```

Switching profiles is applied by `./install`, not `make all`. The stamp records
the previous profile, modules, and tools; after the new selection installs, each
dropped module runs its `clean` target and mise tools owned by the previous
modules/profile are uninstalled. Base tools (`make`, `shellcheck`, `shfmt`),
shared/unclassified catalog entries, and tools declared in a machine-local mise
config are never removed. Switching back reinstalls what the profile needs;
`DOTFILES_KEEP_TOOLS=1 ./install` keeps the old tools instead.

`make all` only relinks the current selection and warns about missing active
tools. Use `make tools.install` to install them, `make prune.links` for stale
links, and `make <module>.clean` for one module.

### Tool ownership

[`mise.toml`](./mise.toml) is the single version catalog;
[`tools.mk`](./tools.mk) maps each catalog entry to the module that needs it, plus
profile-scoped extras (the demo/video tools in `workstation`/`full`, and
`libqrencode`/`graphviz` in `full`). An unowned entry is treated as shared:
installed on every profile, never auto-removed, and reported by `make tools.check`
so the omission is visible. A new module needs an explicit `TOOLS_<module>`
declaration (empty is valid).

```bash
make tools.list                  # active tools for the selected profile
make tools.install               # install just those tools
make tools.check                 # validate ownership against mise.toml (offline)
```

### Versions and lockfile

CLI tools and LSP servers are pinned to exact versions, so an upgrade is a
deliberate, reviewable commit. Language runtimes (`go`, `node`, `python`, `make`)
keep a minor range so patch releases flow. Bump a tool with `make outdated` →
edit [`mise.toml`](./mise.toml) → commit → `./install` (or `make tools.install`).
`make upgrade.tools` stays within the pinned ranges and never rewrites them.
GNU Make is pinned the same way: macOS ships Make 3.81 without `--output-sync`,
so the pinned 4.x keeps the parallel module pass identical across platforms.

[`mise.lock`](./mise.lock) records the exact resolved version, URL, and checksum
per platform (`linux-x64`, `linux-arm64`, `macos-x64`, `macos-arm64`). Refreshing
pins or ranges updates it — commit both together. To refresh every platform after
a bump, run `mise lock --global -p linux-x64,linux-arm64,macos-x64,macos-arm64`
(set `GITHUB_TOKEN` if rate-limited). Tools without upstream checksums
(Docker CLI, ttyd on some platforms) simply have none recorded; strict locked mode
applies only where the lockfile has one.

Range-based upgrades are held for mise's default 24-hour `minimum_release_age`;
exact pins and versions already in `mise.lock` are exempt. One caveat: `rust` is a
rustup-managed `stable` channel and is not reproducible from `mise.toml` — pin it
with a `rust-toolchain.toml` if that matters.

Long-running processes keep old binaries until restarted. `./install` recycles the
tmux server when its version changes (skipped from inside tmux); restart Neovim
and LSP clients yourself after their binaries change. Per-project overrides work
as usual: drop a `mise.toml` in any project and mise switches on `cd`.

## Modules

Each module is an independent directory with a `Makefile` that symlinks its config
into the XDG directories (`~/.config`, `~/.local/share`, …). Tool binaries are
never installed by modules; they come from `mise.toml`, so the same pins work on
Linux and macOS (Apple Silicon). Destination conflicts are refused, not replaced
— see [Conflicts and recovery](#conflicts-and-recovery).

| Module | Configures |
|---|---|
| `bin/` | Personal scripts |
| `zsh/` | Zsh env, path, aliases, antigen plugins |
| `tmux/` | tmux config, TPM plugins |
| `git/` | Git config, aliases, delta pager |
| `tig/` | Tig Git browser |
| `fzf/` | fzf config and shell integration |
| `nvim/` | Neovim / LazyVim |
| `alacritty/` | Alacritty terminal |
| `fonts/` | Powerline + JetBrains Mono Nerd Font |
| `golang/` | Go env; gofumpt, goimports, govulncheck |
| `kubernetes/` | kubectl aliases and completions |
| `helm/` | Helm config and completions |
| `terraform/` | Terraform config and vendored completion |
| `docker/` | Docker aliases (`rd-docker` targets Rancher's client) |
| `bat/` | bat config |
| `ripgrep/` | ripgrep config |
| `psql/` | psql config |
| `rust/` | Rust toolchain and stylua |
| `sops/` | sops config and `sops-age-key-from-wbs` helper |
| `whalebyte/` | whalebyte config and the `wbs` vault CLI |
| `agents/` | Shared AI instructions and skills |
| `opencode/` | OpenCode config, commands, plugins |
| `copilot/` | Optional Copilot CLI config and MCP servers |

See [`nvim/README.md`](./nvim/README.md) for editor setup and maintenance.

### AI agents

OpenCode and Copilot share [engineering instructions](./agents/instructions/engineering.md)
and [skills](./agents/skills/) from `agents/`; client-specific settings stay in
`opencode/` and `copilot/`.

```bash
make agents                  # shared instructions and skills
make opencode                # shared files + OpenCode config
make copilot                 # shared files + Copilot config (optional)
make -C agents sync-skills   # refresh the commit skill; review the diff
```

Use the root targets so shared files install first. Copilot links into
`${COPILOT_HOME:-$HOME/.copilot}` without replacing personal instructions or
session data. See [`agents/EVALUATION.md`](./agents/EVALUATION.md) for discovery
and quality checks.

Machine-local MCP endpoints stay out of git. Create an ignored
`copilot/mcp-config.local.json` (mode `600`, token inline) and `make copilot`
links it as `mcp-config.json` in place of the tracked gopls-only baseline; this
covers both the CLI and Desktop. OpenCode needs no repo change: an `opencode.json`
in a project parent directory merges over `~/.config/opencode/opencode.json`.

- **Go:** the [`go-development` skill](./agents/skills/go-development/SKILL.md)
  is shared by both clients; `gopls mcp` provides saved-file context.
- **Terse replies:** the opt-in [`caveman` skill](./agents/skills/caveman/SKILL.md)
  changes chat style only.
- **Copilot Desktop:** reuses CLI skills and MCP servers but manages its own
  preferences; check **Customize → Skills/MCP** and ensure `gopls` is on its PATH.

### Rancher Desktop

Rancher ships its own `kubectl`, `helm`, and `docker` in `~/.rd/bin`. mise shims
come first on `PATH`, so plain `kubectl` is the generic client. Use `rd-kubectl`,
`rd-helm`, and `rd-docker` to target Rancher's cluster.

### Kubernetes debugging

Ephemeral troubleshooting containers live in
[kwtucker/k8s-debug](https://github.com/kwtucker/k8s-debug). It consumes this
repo's `nvim/` config at a pinned commit and sets `K8S_DEBUG=1`, which makes
`nvim/lua/plugins/mason.lua` skip Mason installs.

## Checking state

`make status` and `make doctor` are read-only and offline by default; only
`doctor --online` makes network requests.

```bash
make status                    # repository + applied + filesystem overview
make status ARGS=--json        # machine-readable
make status ARGS=--exit-code   # fail on drift (links, stamp, active tools)
make doctor                    # PASS/WARN/FAIL with a fix for each problem
make doctor ARGS=--online      # also check mise updates and origin reachability
scripts/state check-links      # fast expected-link verification
make prune.links               # list stale links into this checkout (dry run)
make prune.links ARGS=--force  # remove them
```

`scripts/state doctor` exits `0` with warnings, `1` on failure, `2` on usage
error. Through `make`, GNU Make reports a failed recipe as its own status (`2`);
call `scripts/state doctor` directly to distinguish the two.
`scripts/state check-links` exits `0` only when every expected link resolves into
this checkout; `--preflight` lists destinations a default install would refuse,
and `--strict` also fails on links into this checkout that are no longer expected.

`make prune.links` touches only symlinks that still resolve inside this checkout
and re-checks ownership immediately before unlinking.

## Conflicts and recovery

### Conflicts and adoption

Installs never delete existing configuration. A real file, real directory, or
symlink pointing outside this checkout is refused by name, and `./install` runs
that preflight for every module before changing anything.

Move the path aside, or opt into adoption:

```bash
DOTFILES_ADOPT=1 ./install          # full update
DOTFILES_ADOPT=1 FORCE=1 ./install  # when the stamp says "already applied"
DOTFILES_ADOPT=1 make bat           # one module
```

Adoption moves the existing path to
`${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/<UTC timestamp>/`, keeping
its `$HOME`-relative path (external paths go under `external/`), and appends
`adopt<TAB>dest<TAB>backup` to `manifest.tsv`. Links into this checkout are
repaired in place without a backup. Sockets, pipes, and device nodes are refused.

```bash
backup=~/.local/state/dotfiles/backups/<timestamp>
rm ~/.config/bat
mv "$backup/.config/bat" ~/.config/bat
```

Re-running the module treats the path as a conflict again by design; `make status`
lists backup runs.

### Rollback

Adoption backups cover individual paths, not whole-home snapshots.

```bash
cd ~/.dotfiles
git switch --detach <known-good-rev>   # or: git switch main to return
make tools.install                     # only if mise.toml/mise.lock changed
FORCE=1 ./install                      # ignore the stamp, relink everything
```

Then restart long-running processes: new shell, detached `tmux kill-server`, and
Neovim/LSP clients. `make doctor` reports leftovers (stale links, missing tools,
stale stamp).

## Machine-local overrides

These files are intentionally untracked:

| File | Purpose |
|---|---|
| `profile.local` | This machine's profile (see [Profiles](#profiles)) |
| `modules.local.mk` | Add extra modules: `LOCAL_MODULES = terraform` |
| `mise.local.toml` | Project-local mise overrides/tools for this checkout only |
| `~/.config/mise/config.local.toml` | Machine-wide mise tools not in the catalog (not created by `./install`) |
| `git/config.local` | Per-machine git identity/auth (copy from `git/config.local.example`) |
| `copilot/mcp-config.local.json` | Machine-local Copilot MCP servers/token, linked instead of the tracked `mcp-config.json` |
| `zsh/local` | Local env vars, tokens, secrets |

`mise.local.toml` is scoped to the checkout and does not replace the global
`~/.config/mise/config.toml` link, so tools outside `~/.dotfiles` keep the
`mise.toml` pins. Use it for experiments; make lasting changes in `mise.toml` and
commit them. The stamp hashes `modules.local.mk` and `mise.local.toml`, so editing
either triggers a full pass on the next `./install`.

Tools declared in either local mise file are protected from profile cleanup, so
one-machine additions survive switching to a smaller profile. Use
backend-qualified names (`aqua:jqlang/jq`) where possible; short names also match.

## Supply chain

Everything installed outside mise is fetched by `scripts/fetch`, which rejects
non-HTTPS URLs, empty or oversized responses, and SHA-256 mismatches before moving
a file into place. Pins and digests live together in tracked files:

| Artifact | Pin |
|---|---|
| mise bootstrap | `MISE_BOOTSTRAP_VERSION` in `scripts/bootstrap-mise.sh`; archive verified against `SHASUMS256.txt` |
| `wt` | `WT_VERSION` + `WT_SHA256` in `git/Makefile` |
| antigen | `ANTIGEN_VERSION` + `ANTIGEN_SHA256` in `zsh/Makefile` (vendored) |
| `fzf-tmux` | `FZF_TMUX_VERSION` + `FZF_TMUX_SHA256` in `fzf/Makefile` |
| TPM | `TPM_VERSION` + `TPM_COMMIT` in `tmux/Makefile` |
| fonts | `INCONSOLATA_*` and `JETBRAINS_*` version/checksum pairs in `fonts/Makefile` |

A pin bump is always two edits: the version/commit and the matching digest. Then
run the module's `upgrade` target (or `./install` / `make fonts`), confirm with
`make doctor`, and commit the pin, digest, and any vendored file together. Never
push a bump whose download has not succeeded on a clean machine.

TPM is installed and pinned by the tmux module and deliberately not listed as a
plugin, so `make tmux.upgrade`, `prefix + r`, and TPM's own commands never pull it
off its tag; change it only through `TPM_VERSION`/`TPM_COMMIT`. Terraform's zsh
completion is vendored under `terraform/completions/`. Bootstrap never pipes a
remote script into a shell and fails instead of falling back when a checksum
cannot be fetched.

## Command reference

| Target | Description |
|---|---|
| `make install` / `make update` | Install or update this machine (runs `./install`) |
| `make all` | Relink the selected profile's modules in parallel |
| `make profile.list` | List profiles and mark the active one |
| `make profile.show` | Show profile, modules, and tool count |
| `make profile.set` | Save this machine's profile (`PROFILE=<name>`) |
| `make profile.clear` | Remove `profile.local` and fall back to `full` |
| `make tools.list` / `make tools.install` | Show / install the active profile's tools |
| `make tools.check` | Validate tool ownership against `mise.toml` (offline) |
| `make status` / `make doctor` | Read-only state and diagnostics |
| `make prune.links` | Remove stale links into this checkout (dry run; `ARGS=--force`) |
| `make clean.all` | Remove owned links, completions, and helper binaries for the selected profile |
| `make [module]` / `make [module].clean` | Install / clean one module |
| `make outdated` | Preview outdated tools (no changes) |
| `make upgrade.tools` | Upgrade within pinned ranges; refresh `mise.lock` and completions |
| `make prune.tools` | Remove superseded mise tool versions |
| `make upgrade.plugins` | Upgrade modules with an `upgrade` target (`nvim`, `tmux`, `zsh`, `opencode`) |
| `make upgrade.all` | `upgrade.tools` + `upgrade.plugins` |
| `make [module].upgrade` | Upgrade one module's plugins |
| `make help` | List all targets |

`make clean.all` removes only paths this repository owns: module links, generated
completions, `~/.zshenv`, `wt`, `fzf-tmux`, fetched fonts, the module cache, and
empty module data directories. It never follows a tracked file, removes a real
config directory, or deletes unrelated files in shared directories such as
`~/.local/bin`. Fonts are copied, so only exact pinned filenames and version
markers are removed.

Completion paths follow the `XDG_DATA_HOME` of the Make run; an inherited
`ZSH_COMPLETIONS_DIR` is ignored so a temporary-home install cannot reach another
home. Pass `ZSH_COMPLETIONS_DIR=/path` on the Make command line to override.

`copilot` is optional: install with `make copilot`, or add it to `LOCAL_MODULES` in
`modules.local.mk` to include it in `make all`. Additional opt-in modules go in
`OPTIONAL_MODULES` in the root `Makefile`.
