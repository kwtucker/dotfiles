# Tig

Git browser preferences. Mise supplies Tig through its Conda backend.

## How-to apply and use

Provision the profile's tools and run `make tig` from the dotfiles root.
Run `tig` inside a Git repository to browse history; this is an interactive
application, not a documentation validation command.

## Reference

- Config link: `$XDG_CONFIG_HOME/tig`.
- [config](config): split width/height and wrapped lines.
- `make tig.clean`: remove only the exact config-directory link owned by this
  module. Unlike modules using shared cleanup, it does not delete a cache tree.

## Explanation

These files tune the browser, not Git identity or authentication. See the
[Git module](../git/README.md) for those concerns and the shared
[tool ownership reference](../docs/reference/profiles-and-tools.md) for pins.
