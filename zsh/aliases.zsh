
# -------------------------------------------------------------------
# Alias 
# -------------------------------------------------------------------
alias reload!='exec "$SHELL" -l'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

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



# ---- dotfile python ----
alias python=/usr/local/bin/python3
alias pip=/usr/local/bin/pip3

# ---- dotfile git pull ----
alias dotpull='pwd=`pwd` && cd ~/.whalebyte/dotfiles && git pull && sleep 6 && cd $pwd'

# ---- dotfile git push ----
alias dotpush="cd $WHALEBYTE/dotfiles && gaa && gcmsg 'update dotfiles' && git push origin master && cd -"

# ---- dotfile cd ----
alias dot='cd ~/.whalebyte/dotfiles'

if [ $commands[exa] ]; then
  alias ls='exa'
  alias ll='exa -lg --git --time-style long-iso'
  alias la='exa -laag --git --time-style long-iso'
else
  if [ "$(uname -s)" = "Darwin" ]; then
    if [ $commands[gls] ]; then
      alias ls="gls --color=tty --quoting-style=literal -h"
    else
      alias ls='ls -FG'
    fi
  else
    alias ls='ls -F --color'
  fi
  alias la="ls -lah"
  alias ll="ls -lh"
fi
alias docker_rm_all="docker rm \`docker ps -a -q\`"
alias docker_rmi_all="docker rmi \`docker images -q\`"
alias docker_rmi_dangling="docker rmi \`docker images -qa -f 'dangling=true'\`"
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
