require("user.lsp.languages.go")
require("user.lsp.languages.rust")
require("user.lsp.languages.sh")

vim.lsp.diagnostics.virtual_text = false
vim.lsp.diagnostics.float.focusable = true

lvim.builtin.treesitter.ensure_installed = {
  "go",
}

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  -- { command = "stylua",   filetypes = { "lua" } },
  { command = "shfmt",    filetypes = { "sh", "zsh" } },
  { command = "deno_fmt", filetypes = { "markdown" } }
})
