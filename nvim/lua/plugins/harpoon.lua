return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})
      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      vim.keymap.set("n", "<C-e>", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })
    end,
    -- stylua: ignore
    keys = {
      { "<leader>ha", "<cmd>lua require('harpoon').list():add()<CR>", desc = "Harpoon file", mode="n"  },
      { "<leader>he", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon').list())<CR>", desc = "Harpoon quick menu", mode="n"  },
      { "<leader>h1", "<cmd>lua require('harpoon').list():select(1)<CR>", desc = "Harpoon to file 1",  mode="n" },
      { "<leader>h2", "<cmd>lua require('harpoon').list():select(2)<CR>",  desc = "Harpoon to file 2",  mode="n" },
      { "<leader>h3", "<cmd>lua require('harpoon').list():select(3)<CR>",  desc = "Harpoon to file 3",  mode="n" },
      { "<leader>h4", "<cmd>lua require('harpoon').list():select(4)<CR>",  desc = "Harpoon to file 4",  mode="n" },
      { "<leader>h5", "<cmd>lua require('harpoon').list():select(5)<CR>",  desc = "Harpoon to file 5",  mode="n" },
    },
  },
}
