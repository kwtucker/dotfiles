set nocompatible              " be iMproved, required
filetype off                  " required
syntax on
"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'rizzatti/dash.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
"Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/syntastic'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ctrlp.vim'
"Plugin 'snipMate'
Plugin 'mattn/emmet-vim'
Plugin 'myusuf3/numbers.vim'
Plugin 'tpope/vim-surround'
Plugin 'davidhalter/jedi-vim'
Plugin 'elzr/vim-json'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'fatih/vim-go'
Plugin 'mdempsky/gocode', {'rtp': 'vim/'}
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tyrannicaltoucan/vim-deep-space'
Plugin 'majutsushi/tagbar'
Plugin 'joonty/vdebug'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Allow backspace in insert mode
set backspace=indent,eol,start
set hlsearch   "highlight search terms
set incsearch  "show search matches as you type
set showmatch  "set show matching parenthesis
set number
set tabstop=4
set shiftwidth=4
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
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
let NERDTreeShowHidden=1

" Leader is now ,
let mapleader=','


" Sets the nerd tree toggle to control n
map <C-n> :NERDTreeToggle<CR>

"Syntax Highlighting Go-vim
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" Airline tabline
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffers_label = 'Bad Ass Tabs <leader>Number'
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

"Go TagBar
au BufRead,BufNewFile *.go set filetype=go
let g:go_def_mapping_enabled=0
nmap <C-t> :TagbarToggle<CR>
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
	\ }


nmap <Leader>s :w <ENTER>
nmap <Leader>ss :wq <ENTER>
nmap <C-t> :TagbarToggle<CR>

set clipboard=unnamed

" Will un highlight the search results
nmap <Leader>nh :nohlsearch <ENTER>

" Adjust the split view
nmap <Leader>< :20winc < <ENTER>
nmap <Leader>> :20winc > <ENTER>

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

