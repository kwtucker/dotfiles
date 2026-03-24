#!/usr/bin/env zsh

export DOTFILES="$HOME/.dotfiles"

bindkey -e

# Bootstrap XDG so config_files glob works
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Load env files first (PATH, exports, env vars)
typeset config_files
config_files=($XDG_CONFIG_HOME/*/*.zsh)

for file in ${(M)config_files:#*/env.zsh}; do
  source "$file"
done

ZSH_COMPLETIONS_DIR="${XDG_DATA_HOME}/zsh/completions"
mkdir -p "$ZSH_COMPLETIONS_DIR"
fpath=($ZSH_COMPLETIONS_DIR $fpath)

# Initialize completion system
autoload -Uz compinit
if [[ -n ${XDG_CACHE_HOME}/zsh/zcompdump(#qN.mh+24) ]]; then
  compinit -i -d $XDG_CACHE_HOME/zsh/zcompdump
else
  compinit -C $XDG_CACHE_HOME/zsh/zcompdump
fi

# Load everything else (aliases, functions) — excluding env and completion files
for file in ${config_files:#*/env.zsh}; do
  source "$file"
done

# Load antigen plugins
source $XDG_CONFIG_HOME/zsh/antigen.zsh
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle paulirish/git-open
antigen bundle Aloxaf/fzf-tab
antigen apply

# Local overrides
[ -f ${XDG_CONFIG_HOME}/zsh/local ] && source ${XDG_CONFIG_HOME}/zsh/local
[ -f ${WHALEBYTE}/.secret ] && source ${WHALEBYTE}/.secret
[ -f ${WHALEBYTE}/.env ] && source ${WHALEBYTE}/.env

unset config_files
