include ../env.mk

COPILOT_HOME ?= $(HOME)/.copilot
CONFIG_FILES := settings.json mcp-config.json instructions/engineering.instructions.md

.PHONY: install clean

# Link only declarative configuration, never the state/auth/session directory.
install:
	@for file in $(CONFIG_FILES); do \
		source="$(CURDIR)/$$file"; target="$(COPILOT_HOME)/$$file"; \
		if [ ! -e "$$source" ]; then echo "Missing source: $$source" >&2; exit 1; fi; \
		parent="$$(dirname "$$target")"; \
		if { [ -e "$$parent" ] || [ -L "$$parent" ]; } && [ ! -d "$$parent" ]; then \
			echo "Conflict: $$parent is not a directory." >&2; exit 1; \
		fi; \
		if [ -e "$$target" ] || [ -L "$$target" ]; then \
			if [ ! -L "$$target" ] || [ "$$(readlink "$$target")" != "$$source" ]; then \
				echo "Conflict: $$target already exists; merge it into the dotfiles config and move it aside before installing." >&2; \
				exit 1; \
			fi; \
		fi; \
	done
	@set -e; for file in $(CONFIG_FILES); do \
		target="$(COPILOT_HOME)/$$file"; \
		mkdir -p "$$(dirname "$$target")"; \
		if [ ! -L "$$target" ]; then ln -s "$(CURDIR)/$$file" "$$target"; fi; \
	done
	@echo "Copilot configuration and shared engineering instructions installed."

clean:
	@set -e; for file in $(CONFIG_FILES); do \
		target="$(COPILOT_HOME)/$$file"; \
		if [ -L "$$target" ] && [ "$$(readlink "$$target")" = "$(CURDIR)/$$file" ]; then \
			rm "$$target"; \
		fi; \
	done
