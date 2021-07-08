" Allow backspace in insert mode
set backspace=indent,eol,start
set hlsearch
set incsearch  "show search matches as you type
set showmatch  "set show matching parenthesis
set number
set tabstop=2
set expandtab
set shiftwidth=2
set pastetoggle=<f2>
set statusline=%{fugitive#statusline()}
set noshowmode
set laststatus=2
" Update time for vim gutter
set updatetime=250

" Turn off backup and set the undodir
set nobackup

if has("persistent_undo")
	set undodir=$XDG_DATA_HOME/nvim/undo
	set undofile
endif

set number relativenumber

" Theme of work area and tabline
set background=dark

set t_Co=256
set termguicolors

set scrolloff=8
set signcolumn=yes
set colorcolumn=80
set autowrite 
set completeopt+=noselect
set clipboard=unnamed
set splitbelow
set splitright
