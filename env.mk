# env.mk — XDG directories and helper targets

XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_CACHE_HOME  ?= ${HOME}/.cache
XDG_DATA_HOME   ?= ${HOME}/.local/share
ZSH_COMPLETIONS_DIR ?= ${XDG_DATA_HOME}/zsh/completions

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
