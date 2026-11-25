# Neovim tasks

## Update plugins deliberately

Save work and close editing sessions before maintenance. From the dotfiles
root, use `make nvim.upgrade` to update plugins/lockfile and refresh the Mason
registry. This downloads code and changes local state. Review `lazy-lock.json`
afterward; do not automatically keep an unexpected lockfile diff.

Updates do not delete every unused plugin checkout or upgrade every installed
Mason package. Use `:Mason` for deliberate tool maintenance.

## Restore plugin revisions

Preserve local edits and choose the intended `lazy-lock.json` before restoring.
**Known limitation:** `make -C nvim restore` and `prepare` call `manage.install`
before `manage.restore`. lazy.nvim can rewrite the lockfile from installed
revisions during that first step, defeating the intended restore.

For an already-installed plugin set, close old Neovim instances, put the
reviewed lockfile in place, start a fresh instance, and run `:Lazy restore`.
This avoids the maintenance helper's install-first sequence. A session that
cached an older lockfile can write that older state back; do not restore the
file underneath an old session and assume its cached state changed.

Restoring can still rewrite branch metadata or trigger plugin build/startup
behavior. Inspect the resulting diff and installed revisions. Missing plugins
and fresh bootstraps need separate review; do not describe the current helper
as a verified reproducible recovery procedure. No helper fix is included in
this documentation change.

## Install editor tools or prepare a workspace

`make -C nvim mason-install` installs missing packages in the selected profile
and waits for completion. `make -C nvim prepare` also performs plugin restore
and parser setup; it has the restore limitation above. Both may access the
network and run downloaded tools/build steps.

Keep runtime checks in isolated HOME/XDG directories with a copied lockfile.
Never use a working application repository as a disposable fixture.

## Set up AI chat

1. Authenticate interactively in OpenCode, the default ACP backend on both
   macOS and Linux. Provider access is separate from this editor configuration.
2. `make nvim` from the dotfiles root also deploys OpenCode and shared guidance.
   All standard profiles include it; editor-only tool provisioning owns its CLI
   too. Installation can install/prune the CLI; see its [README](../opencode/README.md).
3. Start Neovim from the intended project and run `:checkhealth codecompanion`.
4. Save files before adding disk-backed context, then open chat with Space+a+a.

To use Copilot instead, install/select the optional Copilot module and authenticate
in its CLI. Then override the adapter in the launching environment or ignored
`zsh/local`:

```sh
export CODECOMPANION_ADAPTER=copilot_acp
```

Supported values are `opencode` and `copilot_acp`; unset or invalid values use
OpenCode, without silently falling back to Copilot. For one chat use
`:CodeCompanionChat adapter=copilot_acp`, or `ga` in chat to change adapter.
Unset the environment override to return to OpenCode. Check PATH/authentication
in the same environment that launches the editor. If a running process inherited
an old mise installation path after a tool update, launch a fresh editor with
`mise exec -- nvim` rather than adding version-specific install directories.
Model smoke tests can incur costs and expose context; syntax/config checks
alone are not a live provider evaluation.

## Review changes

Open `:CodeDiff` or Space+g+d. Moving through the explorer with j/k previews the
selected diff while focus stays in the list. Space+g+g opens LazyGit at the
project root; Space+g+G uses the current directory. Saving, staging, or accepting
an agent edit remains a separate deliberate action.
