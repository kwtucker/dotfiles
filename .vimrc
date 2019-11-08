set nocompatible              " be iMproved, required
filetype plugin on
syntax on
"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Xuyuanp/nerdtree-git-plugin'
" Plugin 'scrooloose/syntastic'
Plugin 'ctrlp.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'wincent/ferret'
Plugin 'tpope/vim-surround'
Plugin 'davidhalter/jedi-vim' " Python autocomplete
Plugin 'joonty/vdebug'
Plugin 'elzr/vim-json'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'fatih/vim-go'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'tpope/vim-commentary' " comment/uncomment lines with gcc or gc in visual mode
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tyrannicaltoucan/vim-deep-space'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-unimpaired'
Plugin 'posva/vim-vue'
Plugin 'prettier/vim-prettier'
Plugin 'othree/javascript-libraries-syntax.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
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

" Update time for vim gutter
set updatetime=250

" Theme of work area and tabline
set background=dark
colorscheme deep-space
let g:airline_theme='deep_space'
let g:airline_powerline_fonts = 1
set t_Co=256
set laststatus=2

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Show hidden files in nerdtree
let NERDTreeShowHidden=1

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Show nerdtree even if a file is not an arg when opening vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Ctrl-P
let g:ctrlp_show_hidden = 1

" Leader is now ,
let mapleader=','

" Sets the nerd tree toggle to control n
map <C-n> :NERDTreeToggle<CR>

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
" autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>d  <Plug>(go-def)
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

" Very magic mode
nnoremap / /\v
vnoremap / /\v

" Quick ESC
imap jj <ESC>
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
