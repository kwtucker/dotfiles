#!/bin/bash

# Sources
source ~/.git-completion.bash
source ~/.git-prompt.sh
# Prompt Start

	# For the prompt to work, you must have the .gitprompt.sh in the home directory.
export PATH=/usr/local/bin:$PATH
# Golang
export GOPATH=$HOME/golang/
export GOROOT=/usr/local/opt/go/libexec/
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
# End Golang

export MONGO_PATH=/usr/local/mongodb  
export PATH=$PATH:$MONGO_PATH/bin

# Colors for prompt
MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[34m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[0;32m\]"
BLACK="\[\033[0;30m\]"
GIT_PS1_SHOWDIRTYSTATE=true
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# This is what you edit to customize the prompt
export PS1=$LIGHT_GRAY" __{ 👾  }\h--[\W] ∆ "'$(
    if [[ $(__git_ps1) =~ \*\)$ ]]
    # a file has been modified but not added
    then echo "'$YELLOW'"$(__git_ps1 " (%s)")
    elif [[ $(__git_ps1) =~ \+\)$ ]]
    # a file has been added, but not commited
    then echo "'$MAGENTA'"$(__git_ps1 " (%s)")
    # the state is clean, changes are commited
    else echo "'$CYAN'"$(__git_ps1 " (%s)")
    fi)'"\n"$LIGHT_GRAY"|""\n"$LIGHT_GRAY"|__"$BLUE"🔵 "$LIGHT_GRAY" "

# Prompt End
# Added by install_latest_perl_osx.pl
[ -r /Users/kevintucker/.bashrc ] && source /Users/kevintucker/.bashrc
