alias k='kubectl'
alias kp='k get pods -o wide'
alias ks='k get services -o wide'
alias ke='k exec -it PODS bash'
alias kl='k logs -f PODS'
alias kdp='k describe pod PODS'
alias kds='k describe service SVC'
alias kcs='k config use-context CTX'
alias kns='k config set-context --current --namespace NAMESPACES'
alias kgc='k config get-contexts'
alias kgsa='k get pod PODS -o json | jq .spec.serviceAccount'
alias kgsan='k get pod PODS -o json | jq .spec.serviceAccountName'
alias -g PODS='$(      kubectl get pods       | FZF)'
alias -g DEPLOY='$(    kubectl get deploy     | FZF)'
alias -g RS='$(        kubectl get rs         | FZF)'
alias -g SVC='$(       kubectl get svc        | FZF)'
alias -g ING='$(       kubectl get ing        | FZF)'
alias -g NAMESPACES='$(kubectl get namespaces | FZF)'
alias -g CTX='$(   kubectl config get-contexts -o=name | sort -fd | fzf-tmux --reverse --multi --cycle)'
alias -g FZF='fzf-tmux --header-lines=1 --reverse --multi --cycle | awk "{print \$1}"'
