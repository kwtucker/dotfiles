require("user.lsp.languages.go")
require("user.lsp.languages.rust")
require("user.lsp.languages.sh")

lvim.lsp.diagnostics.virtual_text = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
	"go",
}

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "stylua", filetypes = { "lua" } },
	{ command = "shfmt", filetypes = { "sh", "zsh" } },
})
