# fzf key bindings — CTRL-T, CTRL-R, ALT-C
# Completions are handled separately via ZSH_COMPLETIONS_DIR/_fzf
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi
