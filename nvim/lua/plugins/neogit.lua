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
    config = true,
    keys = {
      { "<leader>gs", "<cmd>Neogit<cr>", desc = "Status", mode = "n" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit", mode = "n" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Pull", mode = "n" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Push", mode = "n" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches", mode = "n" },
      { "<leader>gB", "<cmd>G blame_line<cr>", desc = "Git Blame", mode = "n" },
    },
  },
}
