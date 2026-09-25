# fzf shell integration — key bindings (CTRL-T, CTRL-R, ALT-C) plus its
# TAB completion widget.
# NOTE: .zshrc sources this file BEFORE antigen loads fzf-tab, because both
# bind TAB and the last one wins. fzf-tab must own TAB for fuzzy completion.
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi
