# Neovim reference

## Configuration and tool ownership

- Config directory: `$XDG_CONFIG_HOME/nvim`; leader is Space, local leader is
  backslash.
- [lazy-lock.json](lazy-lock.json): recorded plugin revisions.
- [lua/config/lazy.lua](lua/config/lazy.lua): LazyVim stable selection and
  disabled update checker; missing bootstrap can still download code.
- [lua/config/tooling.lua](lua/config/tooling.lua): editor-specific package and
  workspace-server selection.
- Mise owns shared Go tools and laptop Stylua, Ruff, terraform-ls, and Marksman.
- Neovim shares ownership of `http:opencode` with the OpenCode module so
  `make tools.install MODULES=nvim` includes the default backend CLI. The root
  `make nvim` target installs the OpenCode module/shared guidance first.
- Mason appends to PATH for editor-only tools; existing competing installations
  are not automatically removed.
- Shared server/formatter/linter commands use `mise exec` where configured.
  Project tool pins still apply; install the catalog's tools before editor use.
- `lua/plugins/go.lua` extends LazyVim's Go setup; the Go extra selects
  goimports followed by gofumpt. No global build tags or custom Go root policy
  are configured here.

## Environment variables

| Variable | Meaning |
| --- | --- |
| `CODECOMPANION_ADAPTER` | `copilot_acp` or `opencode`; invalid/unset values use OpenCode on every OS |
| `WORKSPACE_IMAGE=1` | Strict Go/infra Mason/server selection; not a request to mirror laptop tools |
| `K8S_DEBUG=1` | Suppress profile/Mason auto-installation; parser requirements remain separate |
| `NVIM` (Make variable) | Alternate editor executable for maintenance |
| `NVIM_MAINTENANCE=1` | Internal headless maintenance mode |
| `LAZY` | Alternate existing lazy.nvim checkout; missing override is an error |

Workspace-mode settings exist even though no workspace image directory is
present in this checkout. External image projects must pin their own inputs.

## Mappings

| Mapping / command | Action |
| --- | --- |
| `<leader>aa` | Toggle/show/hide the last AI chat |
| `<leader>ac` | Add `#{buffer}` context to chat |
| Visual `<leader>as` | Add the selection to chat |
| Chat `<CR>` / `<C-s>` | Send prompt |
| Chat `<C-c>` | Close chat buffer |
| Chat `?` | Show chat mappings |
| `:CodeCompanionChat PROMPT` | Open chat and submit a prompt |
| `<leader>gb` | fzf-lua branch selection |
| `<leader>gB` | Gitsigns line blame |
| `<leader>gg` / `<leader>gG` | LazyGit at project root / current directory |
| `<leader>gd` / `:CodeDiff` | Live diff review |
| LSP `gd` in Markdown | Marksman link/heading navigation when the server is available |

Gitsigns' standard hunk mappings remain provided by LazyVim in terminal Neovim.

### VS Code

VSCode Neovim uses the same `init.lua` through the installed config link. Leave
`vscode-neovim.neovimClean` off and the custom init path and `NVIM_APPNAME` settings
unset for the default config location. If the extension cannot find `nvim`, set
the platform-specific `vscode-neovim.neovimExecutablePaths` setting in VS Code
User Settings to the full executable path.

When `vim.g.vscode` is set, the config loads shared editing options and
`lua/config/vscode.lua` without starting LazyVim. VS Code handles the UI,
completion, formatting, and language features. The custom mappings are
`<leader>w` (save), `<Esc>` (clear search), `<leader>e` (toggle the primary
sidebar, like `Cmd+B` on macOS), `<leader>ff` (Quick Open), `<leader>/` or
`<leader>fg` (Find in Files), `gd` (definition), and `gr` (references).
Use `<leader>-` to split below and `<leader><Bar>` (`Space`, `|`) to split right.
In Normal mode, `Ctrl+h` moves to the left editor split or, from the leftmost
split, to the visible left sidebar (the file tree when Explorer is active).
`Ctrl+j/k/l` focuses the editor split below, above, or to the right.
While the Explorer file tree has focus, VS Code handles `Ctrl+l` directly to
return to the active editor. Use the binding in `vscode-keybindings.json` in
**Preferences: Open Keyboard Shortcuts (JSON)** for your VS Code profile.
If you already have bindings, merge the entry into the existing array.

Run **Neovim: Restart Extension** after changing the config. In a VS Code editor,
run `:echo $MYVIMRC` to check the loaded init and try `<leader>ff` (Space, `f`, `f`).

## Maintenance commands

| Command from dotfiles root | Actual sequence |
| --- | --- |
| `make -C nvim restore` | Install missing/build-required plugins, then restore; see [limitation](how-to.md#restore-plugin-revisions) |
| `make nvim.upgrade` | Plugin install/update, then Mason registry refresh |
| `make -C nvim mason-install` | Refresh registry and install missing selected packages |
| `make -C nvim prepare` | Plugin install/restore, editor tools, and parsers; restore caveat applies |
| `make nvim.clean` | Remove exact owned config link only |

The helper exits nonzero on reported plugin/registry/package/parser errors.
Mason/parser waits are bounded to 20 minutes; Git operations also use
lazy.nvim timeouts. Successful maintenance does not establish interactive
behavior or an unchanged intended lockfile.
