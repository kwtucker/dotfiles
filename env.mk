XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_CACHE_HOME  ?= ${HOME}/.cache
XDG_DATA_HOME   ?= ${HOME}/.local/share

XDG_DIRS := $(XDG_CONFIG_HOME) $(XDG_CACHE_HOME) $(XDG_DATA_HOME)

.PHONY: .ensure.xdg .remove.xdg

.ensure.xdg.%:
	@echo "Creating XDG dirs for $*"
	@for dir in $(XDG_DIRS); do \
		mkdir -p "$$dir/$*"; \
	done

.remove.xdg.%:
	@echo "Removing XDG dirs for $*"
	@if [ -n "$*" ]; then \
		for dir in $(XDG_DIRS); do \
			rm -rf "$$dir/$*"; \
		done \
	else \
		echo "Error: no module specified!"; exit 1; \
	fi
