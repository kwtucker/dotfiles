return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    event = "VeryLazy",
    config = true,
    -- stylua: ignore
    keys = {
      { "n", "<leader>gg", "<cmd>lua require('neogit').open()<CR>", { noremap = true, silent = true, desc = "Neogit Open" } },
      { "n", "<leader>gc", "<cmd>lua require('neogit').open({ 'commit' })<CR>", { noremap = true, silent = true, desc = "Neogit Commit" } },
      { "n", "<leader>gp", "<cmd>lua require('neogit').open({ 'pull' })<CR>", { noremap = true, silent = true, desc = "Neogit Pull" } },
      { "n", "<leader>gP", "<cmd>lua require('neogit').open({ 'push' })<CR>", { noremap = true, silent = true, desc = "Neogit Push" } },
    },
  },
}
