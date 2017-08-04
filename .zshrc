# Path to your oh-my-zsh installation.
export ZSH=/Users/ktucke214/.oh-my-zsh
export EDITOR=vim
export EVENT_NOKQUEUE=1

ZSH_THEME="pygmalion"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

plugins=(git gitignore brew osx zsh-syntax-highlighting golang)

export PATH="/usr/local/Cellar"
export PATH="/Users/ktucke214/scripts"
# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:/Users/ktucke214/go/bin:/usr/local/mongodb/bin"


# -------------------------------------------------------------------
# General 
# -------------------------------------------------------------------
#export PATH=$PATH:/usr/local/share/dotnet
export PATH="/usr/local/sbin:$PATH"
export PATH=/usr/local/bin:$PATH
export MANPATH="/usr/local/man:$MANPATH"
source $ZSH/oh-my-zsh.sh

export PATH=$HOME/Documents/Kevin/scripts/:$PATH

# -------------------------------------------------------------------
# Python 
# -------------------------------------------------------------------
 #Python virtualenv wrapper
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/python_dev
# source /usr/local/bin/virtualenvwrapper.sh
# # By running the virtualenv_info it will show th current env if activated
# function virtualenv_info { [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') ' }
# export VIRTUAL_ENV_DISABLE_PROMPT=1


# -------------------------------------------------------------------
# Golang 
# -------------------------------------------------------------------
export GOPATH=$HOME/go/
export PATH=$PATH:$GOPATH/bin
#export PATH=$PATH:$GOROOT/bin
export CDPATH=~/go/src/
# export PATH=$HOME/go_appengine:$PATH


# -------------------------------------------------------------------
# Node 
# -------------------------------------------------------------------
# export NVM_DIR="$HOME/.nvm"
# source $(brew --prefix nvm)/nvm.sh


# -------------------------------------------------------------------
# PHP 
# -------------------------------------------------------------------
# For composer PSR 1 and 2 code style PHP
# export PATH="$PATH:$HOME/.composer/vendor/bin"


# -------------------------------------------------------------------
# Alias 
# -------------------------------------------------------------------
# # for the better man pages
alias mana="tldr"
alias v=/usr/local/Cellar/vim/8.0.0647/bin/vim
alias up="cd .. && ls -la |  awk '{print \$9}'"
alias c='clear'
alias zshrc="vim ~/dotfiles/.zshrc"

# ---- GO ----
alias gohome="cd ~/go/src/github.com/kwtucker/ && ls -la | awk '{print \$9}'"
alias gowork="cd ~/go/src/bitbucket.org/cts-rmm/rmm"
alias gowcore="cd ~/go/src/bitbucket.org/cts-rmm/rmm/rmmcore && go build && ./rmmcore -config ./nobuild/rmmcore-dev-notifier.json"
alias gowcores="cd ~/go/src/bitbucket.org/cts-rmm/rmm/rmmcore && go build && ./rmmcore -config ./nobuild/rmmcore-dev-uisplit-notifier.json"
alias gowcoresr="cd ~/go/src/bitbucket.org/cts-rmm/rmm/rmmcore && go build && ./rmmcore -config ./nobuild/rmmcore-dev-receiver.json"
alias gowui="cd ~/go/src/bitbucket.org/cts-rmm/rmm/rmmui && go build && ./rmmui"


# ---- PHP ----
alias composer="php /usr/local/bin/composer.phar"

# ---- C# ----
# alias dn="dotnet"
# alias dnr="dotnet run"
# alias dnbr="dotnet build ; dnr"
# alias dnb="dotnet build"

alias n='vim  -c "NERDTree ~/notes/" "~/notes/info.txt"'
alias nn='function _newNote(){ vim -c "NERDTree ~/notes/general/" "~/notes/general/$1"; };_newNote'

# ---- dotfile git push ----
alias gitdot='pwd=`pwd` && cd ~/dotfiles && gaa && sleep 2 &&  gcmsg "update dotfiles" && sleep 2 && git push origin master && sleep 6 &&  cd $pwd'


# -------------------------------------------------------------------
# Functions 
# -------------------------------------------------------------------

# turn hidden files on/off in Finder
function hiddenOn() { defaults write com.apple.Finder AppleShowAllFiles YES ; }
function hiddenOff() { defaults write com.apple.Finder AppleShowAllFiles NO ; }

# myIP address
function myip() {
  ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
  ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

# Will commit backup for quiver notes. Pass the version in like "quiverB mm/dd/yy"
function quiverB() {
	pw=`pwd`
	if [ ${#1} -ne 0 ]; then
		cd ~/quiver_notes && gaa && sleep 2 &&  gcmsg "backup $1" && sleep 2 && git push origin master && sleep 6
   	else
		cd ~/quiver_notes && gaa && sleep 2 &&  gcmsg "backup" && sleep 2 && git push origin master && sleep 6
   	fi
	cd $pw
}

# Will open 3 terminal window and run:
# ->  port forward to db passed in.
# ->  gowui, This will start the rmmui.
# ->  gowcoresr, This will start the rmm dev receiver.
# ->  gowcores, This will start the rmm dev split notifier.
# Example: rmmuiSplit zorig
function rmmuiSplit() {
	if [ ${#1} -ne 0 ]; then
		cd ~/Library/Application\ Support/iTerm2/Scripts && db=$1 osascript rmmUISplit.scpt
   	else
		cd ~/Library/Application\ Support/iTerm2/Scripts && db=zorig osascript rmmUISplit.scpt
   	fi
	exit
}
