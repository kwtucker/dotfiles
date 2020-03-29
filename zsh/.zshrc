plugins=(golang git helm zsh-syntax-highlighting zsh-autosuggestions git-open)

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
  compinit -i -d ${XDG_CACHE_HOME}/zsh/zcompdump;
else
  compinit -C ${XDG_CACHE_HOME}/zsh/zcompdump;
fi;

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

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

iterm2_print_user_vars() {
  iterm2_set_user_var kubeCurrentContext $(kubectl config current-context)
  iterm2_set_user_var kubeCurrentTillerNamespace $(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"$(kubectl config current-context)\")].context.namespace}")
  iterm2_set_user_var kubeCurrentNamespace $(kubectl config view --minify | grep namespace: | awk 'NR>0 {print $2}')
}

################################################################################
# Load local configurations.
[ -f ${XDG_CONFIG_HOME}/zsh/local.zsh ] && . ${XDG_CONFIG_HOME}/zsh/local.zsh
[ -f ${WHALEBYTE}/secret ] && . $WHALEBYTE/secret
[ -f ${WHALEBYTE}/env ] && . $WHALEBYTE/env
