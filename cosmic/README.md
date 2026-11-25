# COSMIC themes

Opt-in COSMIC Terminal color scheme and COSMIC Desktop theme sources. No
tracked profile includes this module; it does not install COSMIC itself.

## How-to install and import

On a machine with COSMIC installed, run `make cosmic` from the dotfiles root,
or add `cosmic` to ignored `LOCAL_MODULES` for future installs. Existing foreign
destinations are refused. Review a conflict before explicitly adopting it with
`DOTFILES_ADOPT=1 make cosmic`.

In COSMIC Settings → Desktop → Appearance, import the desired Frappé `.ron`
variant from `$XDG_CONFIG_HOME/cosmic/dotfiles-themes/`. Desktop theme selection
is a separate UI step; creating links does not activate it automatically.

## Reference

| Source | Installed path under `$XDG_CONFIG_HOME/cosmic` |
| --- | --- |
| `color_schemes_dark` | `com.system76.CosmicTerm/v1/color_schemes_dark` |
| `themes/` | `dotfiles-themes` |

`make cosmic.clean` asks the link helper to remove these checkout-owned links.
It does not delete COSMIC's config tree, active theme bundles, or imported data.

Sources are vendored from [catppuccin/cosmic-desktop](https://github.com/catppuccin/cosmic-desktop)
at commit `95e81098042dd2102f0b258f6990f886c5759692`, limited to the Frappé
terminal scheme and flamingo/sky round desktop variants. See [LICENSE](LICENSE).

## Explanation

COSMIC owns its mutable configuration tree. The module links source assets,
not the whole tree or version-specific `com.system76.CosmicThemeBundle.*`
output. COSMIC can rewrite the scheme file when using its import/remove UI;
inspect the link and Git diff afterward rather than assuming the tracked
source remains unchanged.
