return {
  {
    "nvim-cmp",
    dependencies = {},
    opts = {
      sources = {
        { name = "nvim_lsp", group_index = 2 },
        { name = "path", group_index = 2 },
        { name = "luasnip", group_index = 2 },
      },
      {
        { name = "buffer" },
      },
    },
  },
}
