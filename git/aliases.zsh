alias -g BRANCHES='$(git branch -l | grep -v "^\*"| fzf-tmux --multi | awk "{print \$1}")'
alias -g deletebranch='git branch -D BRANCHES'

alias g="git"
alias gaa="git add --all"
alias gcmsg="git commit -m"
alias gco="git checkout"
alias gp="git push"

alias tig="tig --all"
alias tis='\tig status'

alias ghpr='gh pr view --web'
alias ghr='gh repo view --web'


