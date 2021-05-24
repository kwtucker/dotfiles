alias -g BRANCHES='$(git branch -l | grep -v "^\*"| fzf-tmux | awk "{print \$1}")'
alias -g deletebranch='git branch -D BRANCHES'

