#!/bin/bash
source ~/.git-completion.bash
export PATH=/usr/local/bin:$PATH

# Golang
export GOPATH=$HOME/golang/
export GOROOT=/usr/local/go/
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
# End Golang

export MONGO_PATH=/usr/local/mongodb  
export PATH=$PATH:$MONGO_PATH/bin
export CUSTOM_SCRIPTS=/Users/kevintucker/scripts
export PATH=$CUSTOM_SCRIPTS:$PATH

export PS1='\n\h › \W => '

alias gitignore='echo "node_modules/\nbower_components/" >> .gitignore'

# Added by install_latest_perl_osx.pl
[ -r /Users/kevintucker/.bashrc ] && source /Users/kevintucker/.bashrc
