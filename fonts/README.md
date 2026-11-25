# Fonts

Verified downloads of Inconsolata for Powerline and JetBrains Mono Nerd Font.
This module copies fonts rather than symlinking a configuration directory.

## How-to install or skip fonts

From the dotfiles root, run `make fonts` to download the pinned files and update
the Linux font cache when available. Use `DOTFILES_SKIP_FONTS=1 make fonts` on a
headless host. The installer detects common container environments; plain SSH
hosts need an explicit skip setting if their selected profile includes fonts.

Set `DOTFILES_SKIP_FONTS=0 ./install` to override automatic skipping. This runs
the full installer, not just the font task. Verify the chosen terminal's font
selection after installation; file presence alone does not prove rendering.

## Reference

| Location | Purpose |
| --- | --- |
| `~/Library/Fonts` | macOS font destination |
| `$XDG_DATA_HOME/fonts` | Linux font destination |
| `$XDG_CACHE_HOME/fonts` | Temporary download/extraction area |
| Font directory `.JetBrainsMono.version` | Installed release marker |
| `$XDG_STATE_HOME/dotfiles/fonts-skipped` | Intentional missing-font skip marker |

Pins and SHA-256 values live in [Makefile](Makefile). `make fonts.clean` removes
the Inconsolata filename, matching `JetBrainsMonoNerdFont*.ttf` files, version
and skip markers, and the module cache. Review matching font filenames first;
cleanup is not limited to symlinks. It may refresh the font cache.

## Explanation

Headless installs usually render through another computer's terminal, so font
downloads are optional. The skip marker distinguishes intentional omission
from missing installation. Reproducible file downloads do not control a
terminal application's font settings.
