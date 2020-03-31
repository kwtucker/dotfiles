#! /usr/bin/env zsh
#
export FZF_TMUX=1
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --preview 'bat --color=always {} | head -40'"
export FZF_DEFAULT_COMMAND='fd -I --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
