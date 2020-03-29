# Path to your oh-my-zsh installation.
export ZSH=/Users/$USER/.oh-my-zsh
export EDITOR=nvim
export EVENT_NOKQUEUE=1
export ZSH_THEME=""

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
export HIST_STAMPS="mm/dd/yyyy"
plugins=(golang git helm zsh-syntax-highlighting zsh-autosuggestions git-open)

################################################################################
# Export XDG locations.
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_RUNTIME_DIR=${HOME}/tmp/runtime

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
unset config_files 


source $ZSH/oh-my-zsh.sh

# Base16 Shell
export BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

autoload -U promptinit; promptinit
prompt pure

# -------------------------------------------------------------------
# Python 
# -------------------------------------------------------------------
 #Python virtualenv wrapper
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/python_dev
# source /usr/local/bin/virtualenvwrapper.sh
# By running the virtualenv_info it will show th current env if activated
# function virtualenv_info { [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') ' }
# export VIRTUAL_ENV_DISABLE_PROMPT=1

# TODO: Abstract this to local file
. ~/.whalebyte/secrets
. ~/.whalebyte/envs

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

iterm2_print_user_vars() {
  iterm2_set_user_var kubeCurrentContext $(kubectl config current-context)
  # iterm2_set_user_var kubeCurrentTillerNamespace $(echo $TILLER_NAMESPACE)
  iterm2_set_user_var kubeCurrentTillerNamespace $(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"$(kubectl config current-context)\")].context.namespace}")
  iterm2_set_user_var kubeCurrentNamespace $(kubectl config view --minify | grep namespace: | awk 'NR>0 {print $2}')
}

################################################################################
# Load local configurations, including $PRIVATE_DOTFILES.
[ -f ${XDG_CONFIG_HOME}/zsh/local.zsh ] && . ${XDG_CONFIG_HOME}/zsh/local.zsh
