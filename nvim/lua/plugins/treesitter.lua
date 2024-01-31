return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "dockerfile",
        "elixir",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "json",
        "json5",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "ron",
        "rust",
        "toml",
        "terraform",
        "typescript",
        "hcl",
        "yaml",
      })
    end,
  },
}
