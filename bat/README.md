# Bat

Syntax-highlighted file viewing with a TwoDark theme. Mise owns the Bat binary;
this module owns shell preferences and a config file.

## How-to use the installed preferences

Provision the selected tools, then run `make bat` from the dotfiles root.
Open a fresh Zsh session and check `bat --version`.

**Current path mismatch:** `env.zsh` sets `BAT_CONFIG_PATH="$HOME/.bat.conf"`,
but the installer does not create that file. To use the tracked `bat.conf`, put
this override in ignored `zsh/local`:

```sh
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/bat.conf"
```

Verify with `bat --config-file` and view a non-sensitive file. This workaround
does not change the shared implementation.

## Reference

- [bat.conf](bat.conf): TwoDark, line numbers/Git changes/header, color output,
  `.ignore` syntax mapping, and `less -FR` pager.
- [env.zsh](env.zsh): `BAT_CONFIG_PATH`, `BAT_THEME`.
- [aliases.zsh](aliases.zsh): shell conveniences.
- Config directory: `$XDG_CONFIG_HOME/bat`.
- `make bat.clean`: remove the owned config link and module cache; shared
  cleanup only removes empty module data directories.

## Explanation

Mise tool ownership and application configuration are separate. The binary can
work even when a config path is wrong; an installed link is not evidence that
Bat reads the intended file. See [safety limits](../docs/explanation/safety-and-reproducibility.md).
