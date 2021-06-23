" Dark powered asynchronous completion framework for neovim/Vim8
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('smart_case', v:true)
" deoplete-go settings
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = [
	\	'package', 'func', 'type', 'var', 'const'
	\]
let g:deoplete#sources#go#package_dot = 1
