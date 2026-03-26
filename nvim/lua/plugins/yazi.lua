return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- open yazi in the current file's directory
      { "<leader>y", "<cmd>Yazi<cr>", desc = "Open yazi (current file)" },
      -- open yazi in the cwd
      { "<leader>Y", "<cmd>Yazi cwd<cr>", desc = "Open yazi (cwd)" },
    },
    opts = {
      open_for_directories = true, -- use yazi instead of netrw for directories
      floating_window_scaling_factor = 0.9,
    },
  },
}
