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
  `zsh/local`, and `git/config.local`. Prefer HOME/XDG-based paths over personal
  absolute paths in reusable configuration.

## Repository map

- `README.md`: installation, module usage, and supported environments.
- `mise.toml`: shared CLI/runtime versions. Pin tool versions deliberately; retain
  existing version-range policies and platform-specific downloads. A tool table
  and its nested `.platforms` table are not duplicate declarations.
- Root `Makefile`: module orchestration; `env.mk` and `platform.mk`: shared XDG
  paths and platform differences. Each module has its own `Makefile` and config.
  Register default modules in `MODULES`, opt-in modules in `OPTIONAL_MODULES`.
  `LOCAL_MODULES` adds machine-specific choices. Preserve parallel-install ordering.
- `install`: bootstrap/update entry point. It can pull Git changes, install/prune
  tools, relink modules, and recycle tmux; it is not a harmless validation command.
- `scripts/`: state and deployment helpers. `scripts/state` backs `make doctor`
  and `make status`; keep it write-free, offline by default, and dependent only
  on bash, git, and standard POSIX tools. `scripts/lib/link.sh` is the
  conflict-safe link helper the module Makefiles call; only it may mutate the
  home directory, and only through the documented adopt/backup path.
  `scripts/lib/stamp.sh` owns the v2 applied-state stamp that gates the install
  fast path; write it only after a successful module pass. `scripts/fetch`
  verifies pinned downloads, and `scripts/bootstrap-mise.sh` installs the pinned
  mise release from verified release checksums.
- `image/`: a separate, deliberately slim Linux workspace image/tool manifest.
  Do not automatically mirror every laptop tool or agent into it.
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

## Validation and reporting

- Use targeted syntax checks, appropriate JSON/JSONC/TOML parsing, link checks, and
  diff review. Do not run Go tooling merely because the user primarily develops Go;
  this repository is configuration, not a Go application.
- For installer checks, isolate HOME, XDG paths, and `COPILOT_HOME` in temporary
  directories. Inspect recipes first: even `make -n` may execute recursive recipes.
- Do not run `./install`, `make all`, update/upgrade/prune, or destructive clean
  targets as routine checks. These change the machine and may access the network.
- Run `git diff --check`. Report exactly what was checked, actual results, and
  anything unverified. Distinguish configuration/discovery checks from live model
  quality evaluations. Leave no temporary validation artifacts in the repository.
