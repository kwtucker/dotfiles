# Alacritty

Terminal preferences, JetBrains Mono Nerd Font selection, keyboard bindings,
and a Catppuccin Frappé theme. This module does not install the Alacritty app.

## How-to apply preferences

Install Alacritty through your platform's application manager. From the dotfiles
root, run `make alacritty`; install [fonts](../fonts/README.md) if needed.
The module is included in `workstation` and `full`.

Inspect the config and launch Alacritty to verify rendering. With live reload
enabled, saved edits can affect an existing terminal immediately. Successful
TOML parsing alone does not validate application-specific fields.

## Reference

- Config: [alacritty.toml](alacritty.toml), linked through
  `$XDG_CONFIG_HOME/alacritty`.
- Theme import: `~/.config/alacritty/catppuccin/catppuccin-frappe.toml`. This
  import is HOME-based; adjust it deliberately for a custom XDG config base.
- Font: JetBrains Mono Nerd Font; inspect the file for size and bindings.
- `make alacritty.clean`: shared cleanup removes the owned config link and
  module cache; it does not uninstall the application or fonts.

## Explanation: TOML and shell startup

There is no `[terminal.shell]` override in the current config. Zsh's automatic
tmux attachment is configured in the [shell module](../zsh/README.md), not here.
If adding nested shell settings, use a normal `[terminal.shell]` table rather
than a multiline inline table that older TOML parsers reject.

Vendored theme documentation remains in [catppuccin/README.md](catppuccin/README.md).
