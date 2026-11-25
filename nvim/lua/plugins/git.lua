return {
  -- CodeDiff owns <leader>gd; clear the fzf-lua git-diff binding first.
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>gd", false },
      {
        "<leader>gb",
        function()
          require("fzf-lua").git_branches()
        end,
        desc = "Git Branches",
      },
    },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      {
        "<leader>gd",
        "<cmd>CodeDiff<cr>",
        desc = "CodeDiff Review Changes",
      },
    },
    opts = {
      explorer = {
        auto_open_on_cursor = true,
        focus_on_select = false,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<leader>gB",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Git Blame Line",
      },
    },
  },
}
