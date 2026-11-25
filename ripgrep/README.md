# Ripgrep

Search defaults and Zsh completion for the mise-managed `rg` binary.

## How-to apply and override search behavior

Provision the selected tools and run `make ripgrep` from the dotfiles root.
Open a fresh Zsh session and inspect `rg --version` and
`$RIPGREP_CONFIG_PATH`. Search a non-sensitive directory to verify the defaults.

Use `rg --no-config ...` when you need upstream behavior without this config,
or override the environment path locally for a project-specific policy.

## Reference

- Config link: `$XDG_CONFIG_HOME/ripgrep`.
- `RIPGREP_CONFIG_PATH`: `$XDG_CONFIG_HOME/ripgrep/config`.
- [config](config): hidden files, smart case, 150-column preview limit, and
  exclusions for `vendor` and `.git`.
- Completion: `$XDG_DATA_HOME/zsh/completions/_rg`.
- `make ripgrep.clean`: owned config link/module cache and `_rg` removal;
  searched project files are untouched.

## Explanation

Defaults change what searches can find. Hidden-file inclusion can reveal local
config; exclusions can omit relevant dependencies. Adjust intentionally rather
than assuming a no-result search proves a symbol or file does not exist.
