set nocompatible              " be iMproved, required
filetype plugin on
syntax on

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary' " comment/uncomment lines with gcc or gc in visual mode
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-markdown'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/syntastic'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'wincent/ferret'
Plug 'elzr/vim-json'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'SirVer/ultisnips'
Plug 'nsf/gocode', {'rtp': 'vim/'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'majutsushi/tagbar'
Plug 'posva/vim-vue'
Plug 'prettier/vim-prettier'
Plug 'othree/javascript-libraries-syntax.vim'
call plug#end()

filetype plugin indent on    " required

" Allow backspace in insert mode
set backspace=indent,eol,start
set hlsearch   "highlight search terms
set incsearch  "show search matches as you type
set showmatch  "set show matching parenthesis
set number
set tabstop=2
set shiftwidth=2
set pastetoggle=<f2>
set statusline=%{fugitive#statusline()}
set noshowmode
" Update time for vim gutter
set updatetime=250

" Theme of work area and tabline
set background=dark
colorscheme palenight
" let base16colorspace=256  " Access colors present in 256 colorspace
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

set t_Co=256
set termguicolors
let g:airline_theme='bubblegum'
let g:airline_powerline_fonts = 1
set laststatus=2

let g:netrw_banner = 0 
let g:netrw_liststyle = 3

let g:fzf_prefer_tmux = 1

nnoremap <C-p> :Files<Cr>
nnoremap <C-g> :Rg<Cr>

" Leader is now ,
let mapleader=' '

let g:used_javascript_libs = 'underscore,jquery,chai'
let g:vue_pre_processors = ['scss']

" print semicolons
" Prettier default: true
let g:prettier#config#semi = 'false'

" single quotes over double quotes
" Prettier default: false
let g:prettier#config#single_quote = 'true'

" print spaces between brackets
" Prettier default: true
let g:prettier#config#bracket_spacing = 'true'

" put > on the last line instead of new line
" Prettier default: false
let g:prettier#config#jsx_bracket_same_line = 'false'

" avoid|always
" Prettier default: avoid
let g:prettier#config#arrow_parens = 'avoid'

" none|es5|all
" Prettier default: none
let g:prettier#config#trailing_comma = 'none'

" flow|babylon|typescript|css|less|scss|json|graphql|markdown
" Prettier default: babylon
let g:prettier#config#parser = 'flow'

" always|never|preserve
let g:prettier#config#prose_wrap = 'preserve'

" css|strict|ignore
let g:prettier#config#html_whitespace_sensitivity = 'css'

"Syntax Highlighting Go-vim
set autowrite " Allow to build go automatically if in a go file
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"

let g:go_def_mode='gopls'

let g:go_info_mode='gopls'

" Dark powered asynchronous completion framework for neovim/Vim8
set completeopt+=noselect
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('smart_case', v:true)
" deoplete-go settings
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#package_dot = 1

autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>d  <Plug>(go-def)
autocmd FileType go nmap <leader>f  <Plug>(go-referrers)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>tc  <Plug>(go-coverage-toggle)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

"Go TagBar
"
au BufRead,BufNewFile *.go set filetype=go
let g:go_def_mapping_enabled=0
nmap <C-t> :TagbarToggle<CR>
nmap <Leader>s :w <ENTER>
nmap <Leader>ss :wq <ENTER>
nmap <C-t> :TagbarToggle<CR>

map <C-j> <C-W>j
map <C-k> <C-W>k
map <bs>  <C-W>h
map <C-l> <C-W>l

set clipboard=unnamed

" Will un highlight the search results
nmap <Leader>nh :nohlsearch <ENTER>

" Adjust the split view
nmap <Leader>> :20winc < <ENTER>
nmap <Leader>< :20winc > <ENTER>
set splitbelow
set splitright

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
