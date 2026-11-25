# Update dotfiles and tools

Use this guide for an existing installation. Commands run from the checkout
root. Save work in terminal/editor sessions and inspect pending Git changes
before updating.

## Inspect before applying

```sh
git status --short --branch
make profile.show
make status
```

Preserve local edits; do not reset or discard them to make an update pass.
Resolve overlapping upstream changes deliberately. To update only the Git
checkout, use `git pull --ff-only`; this does **not** install or relink anything.

## Apply the active profile

```sh
./install
```

`make update` and `make install` invoke the same entrypoint. On a machine with
mise and Neovim on PATH, it attempts a fast-forward pull. If that pull fails, it
reports the problem and continues applying local files: a successful install
does not establish that the checkout is current.

The installer ensures selected tools, applies modules when needed, cleans
modules/tools dropped by a profile change, and prunes superseded tool versions.
It can stop a tmux server after a detected binary change when run outside tmux.
Read the [side-effect reference](../reference/commands.md) and
[safety explanation](../explanation/safety-and-reproducibility.md).

Force a module pass only when needed:

```sh
FORCE=1 ./install
```

`FORCE` does not make the operation read-only or disable cleanup.

## Update tool pins deliberately

Preview available versions with `make outdated` or `mise outdated --bump`.
Edit the intended entries in `mise.toml`, then resolve only those tools in the
lockfile. For example, after a deliberate GnuPG pin change:

```sh
mise lock --global conda:gnupg -p linux-x64,linux-arm64,macos-x64,macos-arm64
make tools.check
git diff -- mise.toml mise.lock tools.mk
```

The `--global` form matches this checkout's installed global mise config link.
Without that link, target the actual config root rather than locking a different
configuration. Lock resolution accesses the network but does not install tools.
Apply with `./install` after reviewing the diff.

`make upgrade.tools` stays within requested selectors; it can advance ranged
tools, refresh the lockfile/completions, and prune. It does not rewrite exact
pins. Plugin updates use separate module targets, such as `make nvim.upgrade`
or `make tmux.upgrade`; these also change state and may access the network.

## Verify and refresh running processes

```sh
make status
make doctor
git diff --check
```

Review any tool/plugin lockfile changes. Restart editor/LSP processes after
their binaries change. Do not kill tmux while it holds work you need. OpenCode
V2 watches valid configuration edits; use its service commands only when a
service is unhealthy or needs to activate a changed binary, not for every edit.
