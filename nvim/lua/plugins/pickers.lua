return {
  -- Keep Telescope narrowly for the Terraform extensions, not general search.
  { "nvim-telescope/telescope.nvim", cmd = "Telescope", opts = {} },
  {
    "linux-cultist/venv-selector.nvim",
    optional = true,
    enabled = not require("config.tooling").workspace,
    opts = { options = { picker = "fzf-lua" } },
  },
}
