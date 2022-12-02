alias -g BRANCHES='$(git branch -l | grep -v "^\*"| fzf-tmux --multi | awk "{print \$1}")'
alias -g deletebranch='git branch -D BRANCHES'

alias g="git"
alias gb="git branch"
alias gaa="git add --all"
alias gcmsg="git commit -m"
alias gco="git checkout"
alias gp="git push origin"
alias gpl="git pull origin"

alias tig="tig --all"
alias tis="\tig status"
