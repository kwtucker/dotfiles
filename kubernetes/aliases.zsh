alias k='kubectl'
alias kp='k get pods -o wide'
alias ks='k get services -o wide'
alias kj='k get jobs'
alias kc='k get cronjobs'

alias kl='k logs -f PODS'
alias kdp='k describe pod PODS'
alias kds='k describe service SVC'
alias kdj='k describe job JOBS'
alias kdc='k describe cronjob CRONS'
alias kcs='k config use-context CTX'
alias kns='k config set-context --current --namespace NAMESPACES'
alias kgsa='k get pod PODS -o json | jq .spec.serviceAccount'
alias kgsan='k get pod PODS -o json | jq .spec.serviceAccountName'

alias -g PODS='$(  kfuzz pods       )'
alias -g DEPLOY='$(kfuzz deploy     )'
alias -g RS='$(    kfuzz rs         )'
alias -g SVC='$(   kfuzz svc        )'
alias -g ING='$(   kfuzz ing        )'
alias -g CRONS='$( kfuzz cronjobs   )'
alias -g JOBS='$(  kfuzz jobs       )'
alias -g NS='$(    kfuzz namespaces )'
alias -g CTX='$(   kubectl config get-contexts -o=name | sort -fd | fzf-tmux --reverse --multi --cycle)'
alias -g FZF='fzf-tmux --header-lines=1 --reverse --multi --cycle | awk "{print \$1}"'
