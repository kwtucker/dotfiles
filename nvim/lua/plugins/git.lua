return {
  {
    "ibhagwan/fzf-lua",
    keys = {
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
