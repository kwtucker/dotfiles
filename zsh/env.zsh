export EDITOR=nvim
export EVENT_NOKQUEUE=1
export ENV=$USER

export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_RUNTIME_DIR=${HOME}/tmp/runtime

# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
export HIST_STAMPS="mm/dd/yyyy"
export HISTFILE="${XDG_DATA_HOME}"/zsh/history
export HISTSIZE=10000
export SAVEHIST=${HISTSIZE}
