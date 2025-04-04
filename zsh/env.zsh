# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
export HIST_STAMPS="mm/dd/yyyy"
export HISTFILE="${XDG_DATA_HOME}"/zsh/history
export HISTSIZE=10000
export SAVEHIST=${HISTSIZE}

export EDITOR=nvim
export EVENT_NOKQUEUE=1
export ENV=$USER

# MISC.
export CDPATH=$HOME/go/src
export TEX=/Library/TeX/texbin

# Prompt
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/zsh/starship.toml"
eval "$(starship init zsh)"
