
# -------------------------------------------------------------------
# Alias 
# -------------------------------------------------------------------

# for the better man pages
alias m="tldr"
alias ll="exa -abghHliS"
alias up="cd .. && ls -la |  awk '{print \$9,\$10}'"
alias c='clear'
alias v='nvim'
alias vim='nvim'
alias zshrc="vim $WHALEBYTE/dotfiles/zsh/.zshrc"

# ---- GO ----
alias gohome="cd ~/go/src/github.com/kwtucker" 
alias gowork="cd ~/go/src/github.comcast.com/yggdrasil/go"

alias goygg="cd ~/go/src/github.comcast.com/yggdrasil/go"
alias gopillar="cd ~/go/src/github.comcast.com/viper-cog/pillar"
alias golrmui="cd ~/go/src/github.comcast.com/lrm/ui"
alias golrmadp="cd ~/go/src/github.comcast.com/lrm/adapter"
alias golrmpub="cd ~/go/src/github.comcast.com/lrm/publisher"
alias golrmesni="cd ~/go/src/github.comcast.com/lrm/esni"

# ---- PHP ----
alias composer="php /usr/local/bin/composer.phar"


# ---- dotfile git push ----
alias dotpush="pwd=`pwd` && cd $WHALEBYTE/dotfiles && gaa && sleep 2 &&  gcmsg 'update dotfiles' && sleep 2 && git push origin master && sleep 7 && cd $pwd"

# ---- dotfile python ----
alias python=/usr/local/bin/python3
alias pip=/usr/local/bin/pip3

# ---- dotfile git pull ----
alias dotpull='pwd=`pwd` && cd ~/.whalebyte/dotfiles && git pull && sleep 6 && cd $pwd'


# ---- dotfile cd ----
alias dot='cd ~/.whalebyte/dotfiles'

alias docker_rm_all="docker rm \`docker ps -a -q\`"
alias docker_rmi_all="docker rmi \`docker images -q\`"
alias docker_rmi_dangling="docker rmi \`docker images -qa -f 'dangling=true'\`"
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
