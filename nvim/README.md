# Neovim

LazyVim with Blink/native snippets, Catppuccin Frappé, Neo-tree, and fzf-lua.
Git review uses LazyGit, CodeDiff, and Gitsigns; CodeCompanion provides ACP chat.

## Start here

Provision the selected tools, then run `make nvim` from the dotfiles root. Its
OpenCode dependency installs shared guidance and configures/provisions the
default ACP backend before linking this directory under `$XDG_CONFIG_HOME/nvim`.
It can install/prune the OpenCode CLI, so this is not a link-only command.
Conflicts are refused rather than replaced. Opening the editor can bootstrap
missing plugins/tools; it is not a write-free installation check.

- [Maintain plugins and editor tools](how-to.md)
- [Look up mappings, variables, and maintenance commands](reference.md)
- [Understand the editor/tooling design](explanation.md)

## AI chat

Follow the [chat setup guide](how-to.md#set-up-ai-chat). The default is `opencode`
on both macOS and Linux. Copilot is an optional explicit override; authentication
and provider availability are configured outside Neovim.

## Git review

Use Space+g+d or `:CodeDiff` to review changes, and Space+g+g for LazyGit.
See the [mapping reference](reference.md#mappings) for context and selection
controls. Agents, terminal Git, and [Tig](../tig/README.md) remain available;
there is no Neogit, Fugitive, debugger, or test-runner plugin configured here.

## Maintenance warning

The current restore helper installs before restoring, which can rewrite the
intended lockfile from installed plugin revisions. Read the
[restore caveat](how-to.md#restore-plugin-revisions) before using it.
`make nvim.clean` removes only this checkout's config link; plugin data, cache,
undo history, and sessions remain.
