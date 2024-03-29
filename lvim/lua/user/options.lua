lvim.colorscheme = "onenord"
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.builtin.alpha.active = true
lvim.builtin.illuminate.active = false
lvim.builtin.bufferline.active = false
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.breadcrumbs.active = true
lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.cmp.cmdline.enable = false
lvim.builtin.cmp.window.documentation = true
lvim.builtin.cmp.window.completion = {
  border = "rounded",
  winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
}
lvim.builtin.cmp.formatting.source_names = {
  nvim_lsp = "",
  emoji = "",
  path = "",
  calc = "",
  cmp_tabnine = "",
  vsnip = "",
  luasnip = "",
  buffer = "",
  tmux = "",
  copilot = "",
  treesitter = "",
}


local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_b = {
  components.branch,
}

lvim.builtin.lualine.sections.lualine_c = {
  components.diff,
  components.filename,
}

lvim.builtin.lualine.sections.lualine_x = {
  components.diagnostics,
  components.lsp,
  components.treesitter,
  components.filetype,
}

lvim.builtin.lualine.sections.lualine_y = {
  components.spaces,
}

lvim.builtin.lualine.sections.lualine_z = {
  components.location,
}

local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_b = {
	components.branch,
}

lvim.builtin.lualine.sections.lualine_c = {
	components.diff,
	components.filename,
}

lvim.builtin.lualine.sections.lualine_x = {
	components.diagnostics,
	components.lsp,
	components.treesitter,
	components.filetype,
}

lvim.builtin.lualine.sections.lualine_y = {
	components.spaces,
}

lvim.builtin.lualine.sections.lualine_z = {
	components.location,
}

local options = {
  backup = false,                          -- creates a backup file
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  -- termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 100,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = false,                            -- display lines as one long line
  scrolloff = 8,                           -- is one of my fav
  sidescrolloff = 8,
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
}

vim.opt.fillchars = vim.opt.fillchars + "eob: "
vim.opt.fillchars:append({
  stl = " ",
})

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work

vim.filetype.add({
  extension = {
    conf = "dosini",
  },
})
