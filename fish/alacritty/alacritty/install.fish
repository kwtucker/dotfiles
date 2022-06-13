#!/usr/bin/env fish

function cp_to_extra -d "copy to extra"
    echo $argv | read -l src dest
    test -e $dest
        and success "skipped $src"
        or cp $src $dest
        and success "copied $src to $dest"
end

cp_to_extra $DOTFILES/fish/alacritty/alacritty.local.yml $HOME/.extra/alacritty.local.yml

link_file $DOTFILES/fish/alacritty/alacritty.defaults.yml $HOME/.config/alacritty/alacritty.defaults.yml backup
    or abort alacritty link

link_file $HOME/.extra/alacritty.local.yml $HOME/.config/alacritty/alacritty.yml backup
    or abort alacritty link

link_file $HOME/.extra/alacritty.local.yml $HOME/.config/alacritty/alacritty.yml backup
    or abort alacritty link

switch (uname)
case Darwin
    cp_to_extra $DOTFILES/fish/alacritty/osx.shell.yml $HOME/.extra/alacritty.shell.yml
case '*'
    cp_to_extra  $DOTFILES/fish/alacritty/linux.shell.yml $HOME/.extra/alacritty.shell.yml
end

# test -e ~/.extra/alacritty.override.yml
#     and success "~/.extra/alacritty.override.yml exists"
#     or cp_override




# (
#             switch (uname)
#             case Darwin
#                 cp $DOTFILES/fish/alacritty/osx.override.yml ~/.extra/alacritty.override.yml
#             case '*'
#                 cp $DOTFILES/fish/alacritty/linux.override.yml ~/.extra/alacritty.override.yml
#             end
#         )