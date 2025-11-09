#! /usr/bin/env zsh

export DOTFILES="$HOME/.dotfiles"

bindkey -e
################################################################################
# All the ZSH files.
typeset config_files
config_files=($XDG_CONFIG_HOME/*/*.zsh)

################################################################################
# Load the env files
for file in ${(M)config_files:#*/env.zsh}; do
  source "$file"
done
################################################################################
# Load everything but the env files.
for file in ${config_files:#*/env.zsh}; do
  source "$file"
done

################################################################################
# Initialize the autocompletion framework.
autoload -Uz compinit
if [[ -n ${XDG_CACHE_HOME}/zsh/zcompdump(#qN.mh+24) ]]; then
  compinit -i -d $XDG_CACHE_HOME/zsh/zcompdump;
else
  compinit -C $XDG_CACHE_HOME/zsh/zcompdump;
fi;

################################################################################
# Load Antigen Plugins
source $XDG_CONFIG_HOME/zsh/antigen.zsh
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle paulirish/git-open
antigen bundle Aloxaf/fzf-tab

###############################################################################
unset config_files 

# eval "$(direnv hook zsh)"
################################################################################
# Load local configurations.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
[ -f ${XDG_CONFIG_HOME}/zsh/local ] && . ${XDG_CONFIG_HOME}/zsh/local
[ -f ${WHALEBYTE}/.secret ] && . ${WHALEBYTE}/.secret
[ -f ${WHALEBYTE}/.env ] && . ${WHALEBYTE}/.env

