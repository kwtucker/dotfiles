local tools = require("config.tooling")

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Keep LazyVim's formatter selection/order; only change who owns binaries.
      local formatters = { goimports = "goimports", gofumpt = "gofumpt" }
      if not tools.workspace then
        formatters.stylua = "stylua"
        formatters.ruff_format = "ruff"
        formatters.ruff_organize_imports = "ruff"
      end
      opts.formatters = opts.formatters or {}
      for formatter, binary in pairs(formatters) do
        opts.formatters[formatter] = vim.tbl_deep_extend("force", opts.formatters[formatter] or {}, {
          command = "mise",
          prepend_args = { "exec", "--", binary },
        })
      end
    end,
  },
}
