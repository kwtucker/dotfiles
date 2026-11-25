# Fuzzy finder

fzf shell widgets, file/history previews, Git selectors, and the pinned
`fzf-tmux` helper. Tools are declared in mise; install-time helper downloads
are verified by the module.

## How-to use selectors

Provision the selected tools, run `make fzf` from the dotfiles root, then open
a fresh Zsh session. Ctrl-T selects files; Ctrl-R searches history. `fe PATTERN`
opens selected files in `$EDITOR`. tmux-based helpers also require tmux.

History Ctrl-Y uses `pbcopy` in the current config, so that binding is
macOS-specific. On Linux, use ordinary selection or supply a local clipboard
override; package availability alone does not make every widget portable.

## Reference

- [env.zsh](env.zsh): default options and preview/history settings.
- [completion.zsh](completion.zsh): shell integration.
- [function.zsh](function.zsh): `fe`, `tfuzz`, and `_gf`/`_gb`/`_gt`/`_gh`/`_gr`/`_gs` selectors.
- `FZF_DEFAULT_COMMAND` searches hidden/ignored files through fd while excluding
  `.git`; results may include files you would not want to share with an agent.
- Config link: `$XDG_CONFIG_HOME/fzf`.
- Downloaded helper: `~/.local/bin/fzf-tmux`; pin/digest in [Makefile](Makefile).
- `make fzf.clean`: shared config/cache cleanup plus removal of `fzf-tmux` and
  stale `_fzf` completion. The helper is a regular downloaded file, not a link.

## Explanation

`fzf --zsh` produces shell integration, not a standalone `_fzf` completion
function. Zsh loads this integration before fzf-tab so fzf-tab retains the Tab
binding. Fuzzy helpers are interactive and should not be used as unattended
validation commands.
