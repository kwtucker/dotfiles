return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "docker-compose-language-service",
        "dockerfile-language-server",
        "eslint-lsp",
        "glow",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "golangci-lint-langserver",
        "gomodifytags",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "prettier",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "staticcheck",
        "stylua",
        "taplo",
        "terraform-ls",
        "typescript-language-server",
        "yaml-language-server",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.gopls.setup({
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            hints = {
              assignVariableTypes = false,
              compositeLiteralTypes = false,
              compositeLiteralFields = false,
              parameterNames = false,
            },
            staticcheck = true,
            completeUnimported = true,
            buildFlags = { "-tags=unit,integration" },
          },
        },
        on_attach = function(client, bufnr)
          -- Keybindings and other settings for LSP on_attach
          local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
          end
          local opts = { noremap = true, silent = true }

          -- Example keybindings
          buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
          buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
          buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
          buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
          buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
          buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        end,
      })
    end,
  },
}
