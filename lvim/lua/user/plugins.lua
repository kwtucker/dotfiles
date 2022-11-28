lvim.plugins = {
	"lunarvim/colorschemes",
	"RRethy/nvim-base16",
	"ellisonleao/gruvbox.nvim",
	"nvim-treesitter/playground",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"numToStr/Comment.nvim",
	"opalmay/vim-smoothie",
	"kylechui/nvim-surround",
	"moll/vim-bbye",
	"folke/todo-comments.nvim",
	"JoosepAlviste/nvim-ts-context-commentstring",
	"f-person/git-blame.nvim",
	"lewis6991/gitsigns.nvim",
	"ruifm/gitlinker.nvim",
	"folke/zen-mode.nvim",
	"lunarvim/darkplus.nvim",
	"lunarvim/templeos.nvim",
	"TimUntersberger/neogit",
	"sindrets/diffview.nvim",
	"simrat39/rust-tools.nvim",
	"olexsmir/gopher.nvim",
	{
		"saecki/crates.nvim",
		tag = "v0.3.0",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup({
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})
		end,
	},
}
