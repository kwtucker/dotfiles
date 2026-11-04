local lazypath = vim.env.LAZY or (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
  if vim.env.LAZY then
    error("LAZY points to a missing lazy.nvim checkout: " .. lazypath)
  end
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Unable to bootstrap lazy.nvim:\n" .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", version = "*", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- Other plugins are reproducible through lazy-lock.json.
  },
  checker = { enabled = false }, -- Upgrades are explicit, never a startup action.
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
