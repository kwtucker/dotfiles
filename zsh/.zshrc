#! /usr/bin/env zsh

export DOTFILES="$HOME/.dotfiles"

bindkey -e
################################################################################
# All the ZSH files.
typeset -U config_files
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
# Load Antibody Plugins
source $XDG_DATA_HOME/zsh/plugins

################################################################################
unset config_files 

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

iterm2_print_user_vars() {
 iterm2_set_user_var kubeCurrentContext $(kubectl config current-context)
 iterm2_set_user_var kubeCurrentNamespace $(kubectl config view --minify | grep namespace: | awk 'NR>0 {print $2}')
}

################################################################################
# Load local configurations.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh && enable-fzf-tab
[ -f ${XDG_CONFIG_HOME}/zsh/local.zsh ] && . ${XDG_CONFIG_HOME}/zsh/local.zsh
[ -f ${WHALEBYTE}/.secret ] && . ${WHALEBYTE}/.secret
[ -f ${WHALEBYTE}/.env ] && . ${WHALEBYTE}/.env

