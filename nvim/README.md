# Neovim

LazyVim with Blink/native snippets, Catppuccin Frappé, Neo-tree, and fzf-lua.
Telescope remains for the Terraform extensions, not general navigation. Git work
uses LazyGit, agents/the terminal, tig, and inline Gitsigns; there is no Neogit,
Fugitive, Ollama integration, debugger, or test-runner plugin.

## Installation and maintenance

`make nvim` from the dotfiles root links this directory into
`$XDG_CONFIG_HOME/nvim` (default `~/.config/nvim`). Conflicting directories or links
are rejected, not replaced. `make nvim.clean` only removes this checkout's config
link; plugin data, undo history, cache, and sessions are preserved.

Neovim itself is pinned in the mise manifests. LazyVim follows stable releases;
all plugin revisions are recorded in `lazy-lock.json`. Normal startup never updates
existing plugins, but missing plugins can be bootstrapped at their locked revisions.

Run these commands deliberately; they can download tools and modify local state:

| Command (from the dotfiles root) | Effect |
| --- | --- |
| `make -C nvim restore` | Install missing locked plugins and restore installed plugins to the lockfile |
| `make nvim.upgrade` | Explicitly update plugins/lockfile and refresh the Mason registry |
| `make -C nvim mason-install` | Install missing tools in the selected Mason profile and wait for completion |
| `make -C nvim prepare` | Restore locked plugins, install profile tools, and wait for parser installation (image pre-warm) |

Upgrades do not automatically delete unused checkouts or upgrade every Mason
package. Review the lockfile diff; use `:Mason` for deliberate editor-tool upgrades.
The maintenance helper fails on plugin/registry/package/parser errors instead of
printing success after `|| true`. Mason/parser waits are bounded to 20 minutes;
plugin Git operations also use lazy.nvim's own timeouts. `NVIM` can select another
Neovim executable for these targets. Do not run maintenance inside an editing session.

## Tool ownership and language configuration

- Mise owns shared Go tools: gopls, goimports, gofumpt, staticcheck, and
  golangci-lint. The laptop manifest also owns stylua, Ruff, terraform-ls, and Marksman.
- Mason appends to PATH and installs editor-specific tools, not competing copies
  of these managed tools. Existing Mason packages are not forcibly uninstalled.
- Shared LSP/format/lint commands use `mise exec` where configured, respecting
  project tool pins and failing visibly rather than choosing an old Mason copy.
  Install the manifest's tools before opening the editor; mise must be on PATH.
- `lua/plugins/go.lua` extends LazyVim's Go server options. LazyVim retains shared
  capabilities, keymaps, diagnostics, formatting, and other language integrations.
  The Go extra supplies goimports → gofumpt. There are no global Go build tags or
  custom root detection; add genuine project-specific requirements in trusted
  project configuration rather than applying them to every Go project.
- `WORKSPACE_IMAGE=1` selects a strict Go/infra Mason/server profile. Its editor-only
  package list lives in `lua/config/tooling.lua` and is consumed directly by image
  preparation. The image stays smaller than the laptop environment.
- `K8S_DEBUG=1` suppresses profile tool installation and automatic Mason LSP
  installation. Treesitter's own build requirements are separate from that list.
- Laptop and image Neovim, gopls, golangci-lint, and fzf pins are aligned; other
  image tools remain independently pinned to keep this change focused.

## Intentional preferences

- Saving is explicit (`autowrite = false`). YAML and Markdown do not autoformat.
- Markdown wraps at word boundaries and hides line numbers/list markers.
  On the laptop, Marksman provides Markdown link and heading navigation through
  LazyVim's standard LSP `gd` binding. Mise pins and runs the server; Mason does
  not install a second copy. Rendering preferences remain separate.
- `<leader>gb` selects branches with fzf-lua; `<leader>gB` shows Gitsigns line blame.
  LazyVim's Gitsigns hunk mappings remain available. `<leader>gg` opens LazyGit at
  the project root; `<leader>gG` opens it in the current working directory.
- VS Code uses LazyVim's built-in compatibility extra, followed by our small set
  of editor-command mappings. It does not initialize a separate plugin stack.

## Validation

Keep smoke scripts, fake homes, and fixture modules temporary and outside the
dotfiles checkout. Use isolated HOME/XDG directories and a copied lockfile for
runtime checks; normal startup can bootstrap missing plugins/tools. Never use a
working application repository as a disposable fixture. Syntax/configuration
checks do not prove interactive behavior or successful execution on Linux.
