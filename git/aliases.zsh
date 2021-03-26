alias -g BRANCHES='$(git branch -l | fzf-tmux --header-lines=1 --reverse --multi --cycle | awk "{print \$1}")'
alias -g deletebranch='git branch -D BRANCHES'

