return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          mason = false, -- Shared with the shell/AI agents; installed through mise.
          settings = {
            gopls = {
              -- Keep hints quiet without bypassing LazyVim's shared LSP setup.
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        golangcilint = { cmd = "mise", prepend_args = { "exec", "--", "golangci-lint" } },
      },
    },
  },
}
