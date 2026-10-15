-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
---- Disable autoformat for lua files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "yaml" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt.wrap = false
    vim.b.autoformat = false
    -- Fix markdown indentation settings
    vim.g.markdown_recommended_style = 0
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if require("lazy.status").has_updates() then
      require("lazy").update({ show = false })
    end
  end,
})
