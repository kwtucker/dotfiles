#! /usr/bin/env zsh
#
# export FZF_TMUX=1
# export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --preview 'bat --color=always {} | head -40'"
# export FZF_DEFAULT_COMMAND='fd -I --type f --hidden --follow --exclude .git'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


export FZF_TMUX=1
export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow -uu --exclude ".git/*"'
export FZF_DEFAULT_OPTS='--bind ctrl-a:select-all --cycle --layout=reverse'
export FZF_CTRL_T_OPTS='--preview-window right:60% --preview "(bat --style=numbers,changes --wrap never --color always {} || highlight -O ansi -l {} || cat {} || tree -C {}) 2> /dev/null | head -200" --bind "?:toggle-preview"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"
