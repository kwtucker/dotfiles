# Choose or switch profiles

A profile is an installation selection, not a runtime shell mode. Every
installed module remains available in every terminal.

## Preview a selection

From the checkout root:

```sh
make profile.list
make profile.show PROFILE=infra
make tools.list PROFILE=infra
```

These commands do not apply the selection. Consult the
[profile/tool reference](../reference/profiles-and-tools.md) for included modules.

## Save and apply

```sh
make profile.set PROFILE=infra
./install
```

`profile.set` writes ignored `profile.local`. On application, modules removed
from the old selection run their `clean` targets; eligible owned tools are
uninstalled after the new module pass succeeds. Review those modules' cleanup
documentation before moving to a smaller profile. This can delete caches,
helper binaries, fonts, or TPM—not just config links.

To keep dropped tools while still cleaning dropped modules:

```sh
DOTFILES_KEEP_TOOLS=1 ./install
```

This flag does not disable final pruning of superseded tool versions.

## Use a temporary or workspace selection

```sh
DOTFILES_PROFILE=dev ./install
```

The environment takes precedence over `profile.local`. To keep the same
selection in ephemeral workspaces, pass it through the workspace configuration
as described in [remote workspaces](remote-workspaces.md).

## Return to the default

```sh
make profile.clear
./install
```

This removes `profile.local`; it does not unset a `DOTFILES_PROFILE` environment
variable. The default is `full` only when no higher-priority selection applies.
Verify with `make profile.show` and `make status`.
