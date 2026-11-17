include ../env.mk

COPILOT_HOME ?= $(HOME)/.copilot

# An ignored machine-local MCP config takes precedence over the tracked baseline,
# so an MCP endpoint and its token stay out of git. The installed name is always
# mcp-config.json, whichever source is used.
MCP_CONFIG := $(if $(wildcard $(CURDIR)/mcp-config.local.json),mcp-config.local.json,mcp-config.json)
# source:destination — source relative to this directory, destination relative to
# $(COPILOT_HOME).
LINKS := \
	settings.json:settings.json \
	$(MCP_CONFIG):mcp-config.json \
	instructions/engineering.instructions.md:instructions/engineering.instructions.md

.PHONY: install clean

# Link only declarative configuration, never the state/auth/session directory.
install:
	@for pair in $(LINKS); do \
		src="$(CURDIR)/$${pair%%:*}"; dest="$(COPILOT_HOME)/$${pair##*:}"; \
		$(DOTFILES_LINK) preflight_file "$$src" "$$dest"; \
	done
	@for pair in $(LINKS); do \
		src="$(CURDIR)/$${pair%%:*}"; dest="$(COPILOT_HOME)/$${pair##*:}"; \
		$(DOTFILES_LINK) link_file "$$src" "$$dest"; \
	done
	@echo "Copilot configuration and shared engineering instructions installed."

# Remove only links that resolve into this checkout, including a link to the
# machine-local MCP config that is no longer present.
clean:
	@set -e; for pair in $(LINKS); do \
		dest="$(COPILOT_HOME)/$${pair##*:}"; \
		if [ -L "$$dest" ]; then \
			case "$$(readlink "$$dest")" in \
				"$(CURDIR)"/*) rm "$$dest" ;; \
			esac; \
		fi; \
	done
