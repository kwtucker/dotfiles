vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

if vim.g.vscode then
  require("config.vscode")
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
