# env.mk — XDG directories and helper targets

XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_CACHE_HOME  ?= ${HOME}/.cache
XDG_DATA_HOME   ?= ${HOME}/.local/share
XDG_STATE_HOME  ?= ${HOME}/.local/state
ZSH_COMPLETIONS_DIR ?= ${XDG_DATA_HOME}/zsh/completions
DOTFILES_STATE_DIR ?= ${XDG_STATE_HOME}/dotfiles

# Repository root and the shared link helper. This file lives at the repo root,
# so the directory of the include is the root whether a Makefile includes it as
# `env.mk` (root) or `../env.mk` (module).
DOTFILES_ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DOTFILES_LINK := $(DOTFILES_ROOT_DIR)/scripts/lib/link.sh
DOTFILES_FETCH := $(DOTFILES_ROOT_DIR)/scripts/fetch

# Module recipes run the helper as a child process. It reads DOTFILES_ADOPT from
# the environment and must honour the state directory chosen for this Make run.
export XDG_STATE_HOME

# platform.mk must be included *after* the XDG vars above (FONT_DIR uses them)
# platform.mk lives next to env.mk — resolve relative to THIS file so the
# include works no matter which directory make is invoked from.
include $(dir $(lastword $(MAKEFILE_LIST)))platform.mk

.PHONY: .ensure.xdg .remove.xdg

# Create base XDG dirs and module subdirs under cache/data only.
# Config dirs are symlinks — never pre-create them here.
.ensure.xdg.%:
	@echo "Ensuring XDG dirs for $*"
	@mkdir -p "$(XDG_CONFIG_HOME)"
	@mkdir -p "$(XDG_CACHE_HOME)/$*"
	@mkdir -p "$(XDG_DATA_HOME)/$*"

# Remove only module paths this repository owns:
#   config — a symlink that resolves inside this checkout (never a real file/dir)
#   cache  — the module cache directory created by .ensure.xdg.%
#   data   — only when empty; module clean targets remove their generated files
#            (completions, tool data) themselves. Never recurse into user data.
.remove.xdg.%:
	@if [ -z "$*" ]; then \
	    echo "Error: no module specified!" >&2; exit 1; \
	fi; \
	echo "Removing owned XDG paths for $*"; \
	cfg="$(XDG_CONFIG_HOME)/$*"; \
	if [ -L "$$cfg" ]; then \
	    case "$$(readlink "$$cfg")" in \
	        "$(DOTFILES_ROOT_DIR)"/*) rm -f "$$cfg"; echo "Removed $$cfg." ;; \
	        *) echo "Left $$cfg (link target is outside this checkout)." ;; \
	    esac; \
	elif [ -e "$$cfg" ]; then \
	    echo "Left $$cfg (not a link owned by this checkout)."; \
	fi; \
	cache="$(XDG_CACHE_HOME)/$*"; \
	if [ -d "$$cache" ] && [ ! -L "$$cache" ]; then \
	    rm -rf "$$cache"; \
	fi; \
	data="$(XDG_DATA_HOME)/$*"; \
	if [ -d "$$data" ] && [ ! -L "$$data" ]; then \
	    rmdir "$$data/completions" "$$data" 2>/dev/null || true; \
	fi
