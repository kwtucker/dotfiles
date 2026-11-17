include ../env.mk

COPILOT_HOME ?= $(HOME)/.copilot

# Link the tracked global MCP configuration; project-specific servers stay local.
# source:destination — source relative to this directory, destination relative to
# $(COPILOT_HOME).
LINKS := \
	settings.json:settings.json \
	mcp-config.json:mcp-config.json \
	instructions/engineering.instructions.md:instructions/engineering.instructions.md

.PHONY: install clean

# Link only declarative configuration, never the state/auth/session directory.
install:
	@set -e; for pair in $(LINKS); do \
		src="$(CURDIR)/$${pair%%:*}"; dest="$(COPILOT_HOME)/$${pair##*:}"; \
		$(DOTFILES_LINK) preflight_file "$$src" "$$dest"; \
	done
	@set -e; for pair in $(LINKS); do \
		src="$(CURDIR)/$${pair%%:*}"; dest="$(COPILOT_HOME)/$${pair##*:}"; \
		$(DOTFILES_LINK) link_file "$$src" "$$dest"; \
	done
	@echo "Copilot configuration and shared engineering instructions installed."

# Remove only links into this checkout, including legacy local-config links.
clean:
	@set -e; for pair in $(LINKS); do \
		dest="$(COPILOT_HOME)/$${pair##*:}"; \
		if [ -L "$$dest" ]; then \
			case "$$(readlink "$$dest")" in \
				"$(CURDIR)"/*) rm "$$dest" ;; \
			esac; \
		fi; \
	done
