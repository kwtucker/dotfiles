alias -g BRANCHES='$(git branch -l | grep -v "^\*"| fzf-tmux --multi | awk "{print \$1}")'
alias -g deletebranch='git branch -D BRANCHES'

alias tig="tig --all"
alias tis='\tig status'

alias ghpr='gh pr view --web'
alias ghr='gh repo view --web'

