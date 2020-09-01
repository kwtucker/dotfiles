#! /usr/bin/env zsh

PURE_CMD_MAX_EXEC_TIME=10

zstyle :prompt:pure:git:stash show yes

# # change the path color
zstyle :prompt:pure:path color '#BFBFBF'

# # change the color for both `prompt:success` and `prompt:error`
zstyle ':prompt:pure:prompt:*' color white

