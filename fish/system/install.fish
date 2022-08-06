#!/usr/bin/env fish
set -Ux EDITOR nvim
set -Ux VISUAL $EDITOR
set -Ux WEDITOR code
set -U fish_greeting

set -Ux DOTFILES ~/.dots

set -Ua fish_user_paths $DOTFILES/fish/bin $HOME/bin

# Auto load fish functions to the shell.
for f in $DOTFILES/fish/**/functions
	set -Up fish_function_path $f
end

# .fish scripts in ~/.config/fish/conf.d/starship.fish
## are also automatically executed before config.fish.
for f in $DOTFILES/fish/*/conf.d/*.fish
	ln -sf $f ~/.config/fish/conf.d/(basename $f)
end

if test -f ~/.localrcfish
	ln -sf ~/.localrc.fish ~/.config/fish/conf.d/localrc.fish
end

for f in ~/.extra/functions
	set -Up fish_function_path $f
end

abbr --erase c
abbr -a mb 'mkdir -p'
abbr -a rd 'rmdir'

