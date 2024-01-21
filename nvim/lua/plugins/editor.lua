return {
  { "akinsho/toggleterm.nvim", version = "*", config = true },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      -- wk.register(opts.defaults)
      wk.register({
        ["<leader>"] = {
          f = {
            name = "File",
            b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
            c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
            f = { "<cmd>Telescope find_files<cr>", "Find files" },
            t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
            s = { "<cmd>Telescope grep_string<cr>", "Find String" },
            h = { "<cmd>Telescope help_tags<cr>", "Help" },
            H = { "<cmd>Telescope highlights<cr>", "Highlights" },
            l = { "<cmd>Telescope resume<cr>", "Last Search" },
            M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
            r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
            R = { "<cmd>Telescope registers<cr>", "Registers" },
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
            C = { "<cmd>Telescope commands<cr>", "Commands" },
            p = { "<cmd>Telescope projects<cr>", "Projects" },
            n = { "<cmd>enew<cr>", "New File" },
          },
          t = {
            name = "Terminal",
            n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
            u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
            t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
            p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
            f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
            h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
            v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
          },
        },
      })
    end,
  },
}
