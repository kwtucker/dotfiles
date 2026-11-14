# env.mk — XDG directories and helper targets

XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_CACHE_HOME  ?= ${HOME}/.cache
XDG_DATA_HOME   ?= ${HOME}/.local/share
XDG_STATE_HOME  ?= ${HOME}/.local/state
ZSH_COMPLETIONS_DIR ?= ${XDG_DATA_HOME}/zsh/completions

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

XDG_DIRS := $(XDG_CONFIG_HOME) $(XDG_CACHE_HOME) $(XDG_DATA_HOME)

.PHONY: .ensure.xdg .remove.xdg

# Create base XDG dirs and module subdirs under cache/data only.
# Config dirs are symlinks — never pre-create them here.
.ensure.xdg.%:
	@echo "Ensuring XDG dirs for $*"
	@mkdir -p "$(XDG_CONFIG_HOME)"
	@mkdir -p "$(XDG_CACHE_HOME)/$*"
	@mkdir -p "$(XDG_DATA_HOME)/$*"

# Remove module-specific XDG dirs only (does not remove base XDG dirs)
.remove.xdg.%:
	@if [ -n "$*" ]; then \
	    echo "Removing XDG dirs for $*"; \
	    sh -c 'for dir in $(XDG_DIRS); do rm -rf "$$dir/$*"; done'; \
	else \
	    echo "Error: no module specified!"; exit 1; \
	fi
