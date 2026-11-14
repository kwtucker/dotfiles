include ../env.mk

COPILOT_HOME ?= $(HOME)/.copilot
CONFIG_FILES := settings.json mcp-config.json instructions/engineering.instructions.md

.PHONY: install clean

# Link only declarative configuration, never the state/auth/session directory.
install:
	@for file in $(CONFIG_FILES); do \
		source="$(CURDIR)/$$file"; target="$(COPILOT_HOME)/$$file"; \
		$(DOTFILES_LINK) preflight_file "$$source" "$$target"; \
	done
	@for file in $(CONFIG_FILES); do \
		source="$(CURDIR)/$$file"; target="$(COPILOT_HOME)/$$file"; \
		$(DOTFILES_LINK) link_file "$$source" "$$target"; \
	done
	@echo "Copilot configuration and shared engineering instructions installed."

clean:
	@set -e; for file in $(CONFIG_FILES); do \
		target="$(COPILOT_HOME)/$$file"; \
		if [ -L "$$target" ] && [ "$$(readlink "$$target")" = "$(CURDIR)/$$file" ]; then \
			rm "$$target"; \
		fi; \
	done
