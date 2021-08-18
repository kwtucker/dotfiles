set nocompatible              " be iMproved, required
filetype plugin on
syntax on

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
" comment/uncomment lines with gcc or gc in visual mode
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-markdown'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'wincent/ferret'
Plug 'elzr/vim-json'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'stamblerre/gocode', {
	\	'rtp': 'nvim',
	\ 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh'
	\}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'majutsushi/tagbar'
Plug 'posva/vim-vue'
Plug 'prettier/vim-prettier'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'mbbill/undotree'

if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'hrsh7th/nvim-compe'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
endif

call plug#end()

filetype plugin indent on    " required

luafile ~/.config/nvim/lua/plugins/compe.lua

" Leader is now ,
let mapleader=' '

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

nmap <leader>s :w <ENTER>
nmap <leader>ss :wq <ENTER>

" Will un highlight the search results
nmap <leader>nh :nohlsearch <ENTER>

" Adjust the split view
nmap <leader>> :20winc < <ENTER>
nmap <leader>< :20winc > <ENTER>

" Very magic mode
nnoremap / /\v
vnoremap / /\v

" Quick ESC
imap jj <ESC>

" Adds a line below.
nmap oo o<Esc>k

" Disables the arrow keys
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>

nnoremap <esc> :noh<return><esc>

" For error quickfix 
nnoremap <leader>n :cnext<CR>
nnoremap <leader>m :cprevious<CR>
nnoremap <leader>c :cclose<CR>
