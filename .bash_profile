alias goto_whale="cd ~/Sites/CraftyWhale/ghost-0.6.2/content/themes/ghost-theme-whale"

alias goto_sdi="cd ~/Sites/SDI-1505"

alias goto_dws1="cd ~/Sites/dws1"

alias goto_webdesignalive="cd ~/Sites/webdesignalive"

#!/bin/bash

# Sources
source ~/.git-completion.bash
source ~/.git-prompt.sh

# Prompt Start

	# For the prompt to work, you must have the .gitprompt.sh in the home directory.

# Colors for prompt
MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[34m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[0;32m\]"
BLACK="\[\033[0;30m\]"
GIT_PS1_SHOWDIRTYSTATE=true
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# This is what you edit to customize the prompt
export PS1=$LIGHT_GRAY" __{ 👾 }\h--[\W] ∆ "'$(
    if [[ $(__git_ps1) =~ \*\)$ ]]
    # a file has been modified but not added
    then echo "'$YELLOW'"$(__git_ps1 " (%s)")
    elif [[ $(__git_ps1) =~ \+\)$ ]]
    # a file has been added, but not commited
    then echo "'$MAGENTA'"$(__git_ps1 " (%s)")
    # the state is clean, changes are commited
    else echo "'$CYAN'"$(__git_ps1 " (%s)")
    fi)'"\n"$LIGHT_GRAY"|""\n"$LIGHT_GRAY"|__"$BLUE"🔵 "$LIGHT_GRAY" "

# Prompt End
