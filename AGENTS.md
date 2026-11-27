# Dotfiles agent guide

## Scope and safety

- This repository manages personal configuration and development tools for macOS
  and Linux. Keep changes focused on the requested modules; do not modify separate
  application repositories as part of dotfiles work.
- Check `git status --short` before editing. Preserve existing user work and local
  configuration. Do not commit or push unless explicitly requested.
- **Do not add persistent tests, test directories, or test frameworks here.** If
  validation needs scripts, fixtures, or a fake home, put them in a temporary
  directory outside the checkout and remove them afterward.
- Never commit credentials, session data, machine-specific permissions, or tokens.
  Respect ignored local overrides such as `modules.local.mk`, `mise.local.toml`,
  `profile.local`, `zsh/local`, and `git/config.local`. Prefer HOME/XDG-based paths
  over personal absolute paths in reusable configuration.

## Repository map

- `README.md`: installation, module usage, and supported environments.
- `mise.toml`: shared CLI/runtime versions. Pin tool versions deliberately; retain
  existing version-range policies and platform-specific downloads. A tool table
  and its nested `.platforms` table are not duplicate declarations.
- Root `Makefile`: module orchestration; `env.mk` and `platform.mk`: shared XDG
  paths and platform differences. Each module has its own `Makefile` and config.
  `profiles.mk` defines tracked install-time module sets; `PROFILE`, then
  `DOTFILES_PROFILE`, then ignored `profile.local` select one, defaulting to
  `full`. Register default modules in the profile sets; every `*/Makefile` is
  available for `make <module>`. `LOCAL_MODULES` remains additive and
  machine-specific.
  Preserve parallel-install ordering. `tools.mk` maps each `mise.toml` entry to
  the module that needs it plus `PROFILE_TOOLS_<profile>` extras; tools with no
  owner are shared and never auto-removed. Keep backend-qualified names exactly
  as the catalog declares them.
- `install`: bootstrap/update entry point. It can pull Git changes, install the
  active profile's tools, prune, relink modules, recycle tmux, and clean modules
  and owned tools dropped by a profile switch; it is not a harmless validation
  command. `DOTFILES_KEEP_TOOLS=1` skips tool removal.
- `scripts/`: state and deployment helpers. `scripts/state` backs `make doctor`
  and `make status`; keep it write-free, offline by default, and dependent only
  on bash, git, and standard POSIX tools. `scripts/lib/link.sh` is the
  conflict-safe helper for managed links and adoption backups; other steps can
  also write HOME/XDG paths (mise config, state stamp, completions, helpers,
  fonts, plugin state).
  `scripts/lib/stamp.sh` owns the v2 applied-state stamp that gates the install
  fast path; write it only after a successful module pass, including profile
  cleanup. `scripts/lib/tools.sh` holds the pure profile-cleanup comparison used
  by `install`; it must not write. `scripts/fetch` verifies pinned downloads, and
  `scripts/bootstrap-mise.sh` installs the pinned mise release from verified
  release checksums.
- `agents/`: single source for shared engineering instructions and portable skills,
  installed under `~/.agents/`. Keep global context short and detailed references
  on demand. This root `AGENTS.md` is repository guidance, not global agent policy.
- `opencode/`: global OpenCode configuration; `opencode.json` is server/project
  configuration, `cli.json` is terminal configuration. Follow current V2 docs and
  the OpenCode skill when changing OpenCode behavior.
- `copilot/`: CLI configuration and shared instruction links. Desktop reuses CLI
  skills/MCPs, but do not assume all CLI settings apply to Desktop. Preserve the
  user's existing personal instructions, including Obsidian guidance.

## Module conventions

- Follow nearby naming and Makefile style; include `../env.mk` where appropriate.
  Use tabs for recipes and quote paths. Keep macOS/Linux behavior portable.
- Prefer root `make <module>` targets so dependencies run; `opencode` and `copilot`
  depend on `agents`. Do not duplicate portable skills or engineering instructions
  across clients. Keep client-specific MCP configuration in its native format.
- Inspect existing paths before replacing links. New installers should reject
  conflicts, be repeatable, and clean only links they own. Never symlink the entire
  `~/.copilot` state directory into Git or delete it during cleanup.
- Some existing install/clean targets are destructive. Do not copy broad deletion
  patterns into new modules or run them against a real home merely to validate code.
- A new tracked module needs a directory with a `Makefile`, an explicit
  `TOOLS_<module>` declaration in `tools.mk` (empty is valid), and a profile
  entry only if it should install by default. Profile-switch cleanup runs a
  removed module's `clean` target, so keep `clean` limited to owned
  links/artifacts and do not uninstall shared mise tools when
  `DOTFILES_PROFILE_CLEANUP=1`. Run `make tools.check` after touching
  `mise.toml`, `tools.mk`, or `profiles.mk`.

## Validation and reporting

- Use targeted syntax checks, appropriate JSON/JSONC/TOML parsing, link checks, and
  diff review. Do not run Go tooling merely because the user primarily develops Go;
  this repository is configuration, not a Go application.
- For installer checks, isolate HOME, XDG paths, and `COPILOT_HOME` in temporary
  directories. Inspect recipes first: even `make -n` may execute recursive recipes.
  Exercise profile tool cleanup through `scripts/lib/tools.sh` with fixture lists
  and a fake `mise`; do not uninstall real tools to validate it.
- Do not run `./install`, `make all`, `make tools.install`, update/upgrade/prune,
  or destructive clean targets as routine checks. These change the machine and
  may access the network. `make tools.list` and `make tools.check` are read-only.
- Run `git diff --check`. Report exactly what was checked, actual results, and
  anything unverified. Distinguish configuration/discovery checks from live model
  quality evaluations. Leave no temporary validation artifacts in the repository.
