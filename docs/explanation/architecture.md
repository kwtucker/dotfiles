# Architecture and installation state

The system separates **what to configure**, **which tools to install**, and
**whether the current inputs have already been applied**.

## Modules and tools have different responsibilities

Each module owns application config and a Makefile. Most link config into XDG
directories; others copy fonts, install helpers, or manage plugin checkouts.
The root Makefile discovers module directories and runs selected installs in
parallel. OpenCode and Copilot depend on `agents`, so shared instructions and
skills are installed first. Neovim depends on OpenCode, its default ACP backend,
even when installed through the standalone root `make nvim` target. All standard
profiles include OpenCode; Copilot remains optional.

`mise.toml` is the tool catalog, not the active profile. `tools.mk` assigns
module/profile ownership, and `profiles.mk` selects modules. This lets a smaller
profile omit large tooling without copying version declarations into modules.
Some modules still have explicit tool side effects: the OpenCode installer
installs/prunes its mise CLI, and TPM/font/helper downloads are module-managed.

## Configuration is live through symlinks

Most installed config points into this checkout. Editing files, pulling commits,
or changing revisions can affect running applications without another install.
Machine-specific identities, credentials, and generated paths stay ignored;
portable behavior and setup helpers are tracked.

The shell loads module `env.zsh` files first, then other module Zsh files and
local overrides. Merely linking config does not make existing processes inherit
new environment variables. Other shells do not automatically read Zsh files.

## The installer is an orchestrator

`./install` prepares XDG paths, links the global mise config, ensures tools,
checks tmux versions, preflights modeled module links, applies modules, removes
dropped-profile artifacts/tools, and prunes. On its existing-machine path it
attempts `git pull --ff-only`, but a failed pull does not stop local application.

`make all` is not an equivalent update: it applies the selected module set but
does not perform profile-switch cleanup or write the applied-state stamp.
Root module targets additionally run relevant completions.

## Applied-state stamps avoid redundant work

The v2 stamp at `$XDG_STATE_HOME/dotfiles/last-applied` records inputs including
revision, checkout path, XDG bases, selected profile/modules/tools, and supported
local overrides. The fast path also checks tracked worktree changes and expected
links. Active tools are still ensured even if the module pass is skipped.

The stamp is written atomically after successful module application and cleanup.
It is not an installation transaction or backup. Individual steps can already
have modified state when a later step fails. Not every application's runtime
state or ignored file is modeled, so a matching stamp is not proof of complete
application health.

## Offline state inspection is separate

`scripts/state` consumes Make metadata and filesystem evidence for `status`,
`doctor`, and `check-links`. It does not apply config or repair tools. Its offline
default makes it usable on SSH hosts and in disconnected environments; explicit
online checks add remote evidence, not installation.
