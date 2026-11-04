local tools = require("config.tooling")

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- mise/system tools take precedence; Mason supplies editor-only tools.
      opts.PATH = "append"
      local packages = tools.workspace and vim.deepcopy(tools.workspace_packages)
        or vim.list_extend(vim.deepcopy(opts.ensure_installed or {}), {
          "docker-compose-language-service",
          "dockerfile-language-server",
          "eslint-lsp",
          "helm-ls",
          "json-lsp",
          "lua-language-server",
          "prettier",
          "pyright",
          "rust-analyzer",
          "shellcheck",
          "shfmt",
          "taplo",
          "vtsls",
          "yaml-language-server",
        })
      local seen = {}
      tools.mason_ensure = {}
      for _, name in ipairs(packages) do
        -- The Rust extra requests codelldb even without a DAP plugin. Debugger
        -- tooling is not part of this editor workflow.
        local debugger = name == "codelldb" or name == "delve"
        if not tools.debug and not debugger and not tools.mise_packages[name] and not seen[name] then
          seen[name] = true
          tools.mason_ensure[#tools.mason_ensure + 1] = name
        end
      end
      -- Headless maintenance installs explicitly and waits for completion.
      opts.ensure_installed = tools.maintenance and {} or tools.mason_ensure
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local packages = { gopls = "gopls", marksman = "marksman", ruff = "ruff", terraformls = "terraform-ls" }
      local commands = {
        gopls = { "gopls" },
        marksman = { "marksman", "server" },
        ruff = { "ruff", "server" },
        terraformls = { "terraform-ls", "serve" },
      }
      for name, server in pairs(opts.servers) do
        if name ~= "*" then
          if tools.workspace and not tools.workspace_servers[name] then
            opts.servers[name] = { enabled = false }
          elseif type(server) == "table" then
            if tools.debug or tools.maintenance or tools.mise_packages[packages[name]] then
              server.mason = false
            end
            if tools.mise_packages[packages[name]] then
              -- Resolve project pins through mise, even when Neovim changes roots.
              server.cmd = vim.list_extend({ "mise", "exec", "--" }, commands[name])
            end
          end
        end
      end
    end,
  },
  -- Rustaceanvim manages its own LSP outside lspconfig, so disabling the server
  -- table alone would not enforce the workspace's Go/infra-only profile.
  { "mrcjkb/rustaceanvim", optional = true, enabled = not tools.workspace },
  { "Saecki/crates.nvim", optional = true, enabled = not tools.workspace },
}
