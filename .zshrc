# Path to your oh-my-zsh installation.
export ZSH=/Users/kevintucker/.oh-my-zsh
export EDITOR=vv
export EVENT_NOKQUEUE=1

 #Python virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/python_dev
source /usr/local/bin/virtualenvwrapper.sh
# By running the virtualenv_info it will show th current env if activated
function virtualenv_info { [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') ' }

export VIRTUAL_ENV_DISABLE_PROMPT=1

# autoload bashcompinit
# bashcompinit
# source /Users/kevintucker/scripts/wp-completion.bash

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="pygmalion"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git github virtualenv pip python brew osx zsh-syntax-highlighting golang)

# User configuration
export PATH="/Users/kevintucker/scripts:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:/usr/local/go//bin:/Users/kevintucker/golang//bin:/usr/local/mongodb/bin"

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

export GOPATH=$HOME/go/
#export PATH=$PATH:$GOPATH/bin
# Only need to set goroot if go is installed in a custom location
#export GOROOT=/usr/local/go/
#export PATH=$PATH:$GOROOT/bin
export CDPATH=~/go/src/
export PATH=$HOME/go_appengine:$PATH

export PATH=$PATH:/usr/local/share/dotnet

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

export PATH="/usr/local/sbin:$PATH"
export PATH=/usr/local/bin:$PATH

export NVM_DIR="$HOME/.nvm"
  . "$(brew --prefix nvm)/nvm.sh"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.

# For a full list of active aliases, run `alias`.
alias zshrc="vim ~/dotfiles/.zshrc"

# for the better man pages
alias mana="tldr"
alias v=/usr/local/Cellar/vim/8.0.0054/bin/vim

alias up="cd .. && ls -la |  awk '{print \$9}'"
alias c='clear'

# goLang alias
alias gohome="cd ~/golang/src/github.com/kwtucker/ && ls -la | awk '{print \$9}'"

alias composer="php /usr/local/bin/composer.phar"

# ---- C# ----
alias dn="dotnet"
alias dnr="dotnet run"
alias dnbr="dotnet build ; dnr"
alias dnb="dotnet build"

#dotfile git push
alias gitdot='pwd=$(pwd) && cd ~/dotfiles && git add -A && sleep 2 &&  git commit -m "update dotfiles" && sleep 2 && git push origin master && sleep 6 &&  cd $pwd'
