# Path to your oh-my-zsh installation.
export APP_ENV="prod"
export PUBLISHER="https://lrm-publisher.aor.theplatform.com"
# export ADAPTER="https//lrm.aor.theplatform.com"
export ADAPTER="http://localhost:8081"
export SCTEVS="https://sctevs.linear.theplatform.com/scte224"

export ZSH=/Users/$USER/.oh-my-zsh
export EDITOR=vim
export EVENT_NOKQUEUE=1
export ZSH_THEME="agnoster"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
export HIST_STAMPS="mm/dd/yyyy"
fpath=(/usr/local/share/zsh-completions $fpath)
plugins=(golang git zsh-syntax-highlighting)

# -------------------------------------------------------------------
# ENV 
# -------------------------------------------------------------------
export BREW_PATH=/usr/local/Cellar
export SCRIPTS_PATH=/Users/$USER/scripts
export MANPATH=/usr/local/man
export CDPATH=~/go/src
export GOPATH=$HOME/go
export NVM_DIR=$HOME/.nvm
export JAVA_HOME=$(/usr/libexec/java_home)
export NATIVE_PATH="/usr/local/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# -------------------------------------------------------------------
# PATH 
# -------------------------------------------------------------------
export PATH="$BREW_PATH"
export PATH="$PATH:$SCRIPTS_PATH"
export PATH="$PATH:$MANPATH"
export PATH="$PATH:$GOPATH"
export PATH="$PATH:$NVM_DIR"
export PATH="$PATH:$JAVA_HOME"
export PATH="$PATH:$NATIVE_PATH"
export PATH=$PATH:$GOPATH/bin
source $ZSH/oh-my-zsh.sh


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
# PHP 
# -------------------------------------------------------------------
# For composer PSR 1 and 2 code style PHP
# export PATH="$PATH:$HOME/.composer/vendor/bin"
#

. ~/.zsh_aliases
. ~/.zsh_functions

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
