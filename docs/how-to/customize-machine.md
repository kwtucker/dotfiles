# Customize one machine

Use ignored local overrides for identity, credentials, machine paths, or
one-machine module/tool choices. Use tracked files for defaults that every
computer should receive.

## Add a module to the active profile

Edit ignored `modules.local.mk`, preserving any existing entries:

```make
LOCAL_MODULES = copilot
```

Run `make tools.list` to inspect the resolved tools, then apply with `./install`.
You do not need to edit `profiles.mk` for a one-machine addition.

For a one-off configuration install, use `make copilot` or another root module
target. Most module targets do not install their mise-owned tools. To provision
an opt-in module's tools, inspect and then use `make tools.install MODULES=copilot`;
this also includes base/shared tools and the active profile's tool extras.
The OpenCode module additionally installs/prunes its own CLI when writable.

## Set shell preferences

Edit ignored `zsh/local`, which is sourced after shared module files. Keep
machine-specific choices here, for example:

```sh
export CODECOMPANION_ADAPTER=copilot_acp
```

This override requires an installed, authenticated Copilot CLI; OpenCode remains
the default when the variable is unset. Use fresh shells for startup changes.
Environment variables reach subsequently
launched child processes, not other terminals or already-running desktop apps.
Do not put credentials into tracked shell configuration.

## Set Git identity

Follow the [Git identity guide](../../git/how-to.md#configure-an-identity).
`git/config.local` holds the default identity; optional `git/config.github`
overrides it for matching GitHub remotes. Verify effective settings inside the
repository where you will commit.

## Add a local tool override

`mise.local.toml` in this checkout is project-local; it does not replace the
global linked catalog. Use `~/.config/mise/config.local.toml` for machine-wide
local tools. Both are protected from the installer's profile-tool cleanup.
Prefer full backend-qualified tool names and keep tokens out of these files.

See the [environment reference](../reference/environment.md) for path overrides
and selection precedence. Review local overrides before sharing diagnostics.
