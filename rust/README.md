# Rust environment

Cargo environment loading and Zsh completions. Mise owns the `stable` Rust
toolchain selection; this module does not own Stylua (the Neovim module does).

## How-to install and inspect

Provision the profile's Rust tools and run `make rust` from the dotfiles root.
The Zsh environment sources `~/.cargo/env`, so ensure the Rust installation
created it before opening a shell that loads this module. Inspect
`rustc --version` and `cargo --version`.

For a project requiring a reproducible compiler, use its own
`rust-toolchain.toml` rather than assuming the global `stable` channel is fixed.

## Reference

- Config link: `$XDG_CONFIG_HOME/rust`.
- [env.zsh](env.zsh): Cargo environment source.
- Completions: `$XDG_DATA_HOME/zsh/completions/_rustup` and `_cargo`.
- `make rust.clean`: owned config link/module cache and completions; it does not
  remove `~/.cargo` or uninstall project toolchains.

## Explanation

`stable` follows upstream releases, unlike exact CLI pins. Rustup state and
project build artifacts are not application configuration to symlink into Git.
See [version policy](../docs/reference/profiles-and-tools.md#version-policy).
