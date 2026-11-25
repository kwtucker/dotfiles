# Install a minimal environment on a new machine

This tutorial gives you a first working shell/editor environment and shows how
to inspect it. It uses the `minimal` profile; it does not set up cloud accounts,
clusters, a secrets vault, or commit signing.

## Before you begin

Use a macOS or Linux machine you control, with a writable home directory and
network access. Have Git, Bash, Zsh, curl, and standard archive/file utilities
available; Zsh itself is not installed by the mise catalog. The installer
bootstraps mise from a pinned, verified download and
installs Make if it is not already on PATH. The default shell is not changed.

Review or back up existing configuration first. In particular, the installer
force-links `~/.config/mise/config.toml` **before** module preflight; preserve an
existing global mise config yourself. Other module destinations use the
[conflict/adoption workflow](../how-to/recover-configuration.md).

Installations can download plugins as well as tools. They are not whole-machine
transactions and do not provide a whole-home backup.

## 1. Get a checkout

Choose a new destination; do not clone over an existing directory:

```sh
git clone https://github.com/kwtucker/dotfiles.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
```

You should now see the root `Makefile`, `install`, and `mise.toml`.

## 2. Select the small starting profile

In this new checkout, save an ignored, machine-local selection:

```sh
printf '%s\n' minimal > profile.local
```

`minimal` selects the shell, tmux, Git, Tig, fuzzy finder, editor, helper scripts,
shared agent instructions, and OpenCode (the default editor AI backend).
Provider authentication is still a separate step. It does not select graphical fonts or the
infrastructure modules. See the [profile reference](../reference/profiles-and-tools.md).

## 3. Apply the configuration

```sh
./install
```

Expect steps for mise, profile selection, tools, services, modules, and pruning.
If a destination conflicts, stop and inspect the reported path; do not enable
adoption without understanding what will be backed up. A module failure can
leave earlier steps applied, so inspect the result rather than assuming rollback.

## 4. Inspect the result

Still in the checkout:

```sh
make profile.show
make tools.list
make status
make doctor
```

The profile should be `minimal`. Status should identify this checkout and its
applied state; doctor reports missing paths/tools with remediation. Warnings
about personal identities or optional setup do not mean an account was configured.
Resolve failures before relying on the environment.

## 5. Open a new shell

Start Zsh when you are ready to replace this terminal's shell:

```sh
exec zsh
```

Interactive Zsh automatically attaches to tmux's `main` session when outside
tmux. This is intentional; see the [Zsh README](../../zsh/README.md).
Opening Neovim can bootstrap missing plugins and editor tools, so its first
startup is not a read-only validation step.

You now have the shared environment. Next, [customize this machine](../how-to/customize-machine.md)
or [switch to another profile](../how-to/switch-profiles.md).
