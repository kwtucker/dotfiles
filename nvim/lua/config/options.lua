-- Keep only intentional differences from LazyVim's defaults.
vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_explorer = "neo-tree"
vim.g.lazyvim_prettier_needs_config = true
vim.opt.autowrite = false -- Save only when explicitly requested.
vim.opt.spelloptions:append("noplainbuffer")
