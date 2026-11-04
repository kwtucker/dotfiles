local group = vim.api.nvim_create_augroup("dotfiles_filetypes", { clear = true })

-- Preserve hand-edited YAML and Markdown rather than reformatting on save.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "yaml", "markdown" },
  callback = function(event)
    vim.b[event.buf].autoformat = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.list = false
  end,
})
