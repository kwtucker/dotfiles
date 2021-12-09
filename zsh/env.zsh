# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
export HIST_STAMPS="mm/dd/yyyy"
export HISTFILE="${XDG_DATA_HOME}"/zsh/history
export HISTSIZE=10000
export SAVEHIST=${HISTSIZE}

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_RUNTIME_DIR=$HOME/tmp/runtime

export EDITOR=nvim
export EVENT_NOKQUEUE=1
export ENV=$USER

# MISC.
export CDPATH=$HOME/go/src
export TEX=/Library/TeX/texbin

export ZSH_THEME=""
export ZDOTDIR=$XDG_CONFIG_HOME/zsh/
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh/
