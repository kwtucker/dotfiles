#!/usr/bin/env fish

function cp_to_extra -d "copy to extra"
    echo $argv | read -l src dest
    test -e $dest
        and success "skipped $src"
        or cp $src $dest
        and success "copied $src to $dest"
end

link_file $DOTFILES/fish/tmux $HOME/.config/tmux backup
    or abort alacritty link


