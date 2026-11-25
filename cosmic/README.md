# COSMIC module

COSMIC Terminal and COSMIC Desktop theme sources. This module is not in any
install profile: apply it only on machines with COSMIC Terminal.

```bash
make cosmic
# or add `cosmic` to modules.local.mk for ./install / make all
```

## What is linked

- `color_schemes_dark` →
  `$XDG_CONFIG_HOME/cosmic/com.system76.CosmicTerm/v1/color_schemes_dark`
- `themes/` → `$XDG_CONFIG_HOME/cosmic/dotfiles-themes`

The first link is the terminal color scheme COSMIC Terminal reads. If a scheme is
already imported there, move it aside or use `DOTFILES_ADOPT=1 make cosmic` to
back it up. COSMIC can rewrite this file when schemes are imported or removed in
the UI; if that happens, re-copy the desired scheme into this module and commit
the change.

The second link is a stable import location for the source `.ron` themes. The
active desktop theme itself is deliberately not managed: COSMIC Settings expands
an imported theme into version-specific config bundles under
`$XDG_CONFIG_HOME/cosmic/com.system76.CosmicThemeBundle.*`. Import the desired
Frappé variant once from `$XDG_CONFIG_HOME/cosmic/dotfiles-themes/` in
COSMIC Settings → Desktop → Appearance.

## Sources

Vendored from <https://github.com/catppuccin/cosmic-desktop> at commit
`95e81098042dd2102f0b258f6990f886c5759692`, trimmed to the Frappé terminal
scheme and the two Frappé desktop variants already in use (`flamingo+round` and
`sky+round`). Upstream is MIT licensed; see [`LICENSE`](./LICENSE).
