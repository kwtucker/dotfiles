-- lua/config/vscode.lua

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true

local map = vim.keymap.set

-- Save
map("n", "<leader>w", "<Cmd>write<CR>")

-- Clear search
map("n", "<Esc>", "<Cmd>noh<CR>")

-- Use VSCode commands
local vscode = require("vscode")

map("n", "<leader>ff", function()
  vscode.action("workbench.action.quickOpen")
end)

map("n", "<leader>fg", function()
  vscode.action("workbench.action.findInFiles")
end)

map("n", "gd", function()
  vscode.action("editor.action.revealDefinition")
end)

map("n", "gr", function()
  vscode.action("editor.action.goToReferences")
end)

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = not vim.g.vscode,
  },

  {
    "nvim-lualine/lualine.nvim",
    enabled = not vim.g.vscode,
  },

  {
    "folke/noice.nvim",
    enabled = not vim.g.vscode,
  },

  {
    "akinsho/bufferline.nvim",
    enabled = not vim.g.vscode,
  },

  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      if vim.g.vscode then
        opts.dashboard = { enabled = false }
        opts.explorer = { enabled = false }
      end
    end,
  },
}
