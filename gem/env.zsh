#! /usr/bin/env zsh

# export GEM_HOME="$XDG_DATA_HOME"/gem
# export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem
UNAME=`uname -s`
if [ "$UNAME" = "Darwin" ]; then
    export GEM_HOME=/usr/local/opt/ruby/bin
elif [ "$UNAME" = "Linux" ]; then
    export GEM_HOME=$HOMEBREW_PREFIX/opt/ruby/bin
fi
