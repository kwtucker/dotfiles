include ../env.mk

MODULE_NAME := git

# wt — git worktree manager (POSIX sh). Must run as an executable, NOT be
# sourced: `wt version` self-updates by writing to $0, which would be the
# shell itself when sourced.
# Pinned by default like mise tools — bump WT_VERSION, then `make git.upgrade`.
WT_VERSION ?= v0.2.2
WT_URL ?= https://codeberg.org/tuck/wt/raw/tag/$(WT_VERSION)/wt.sh
WT_BIN ?= $(HOME)/.local/bin/wt

.PHONY: install clean upgrade completions

install: .ensure.xdg.git
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@if [ ! -f "$(XDG_CONFIG_HOME)/$(MODULE_NAME)/config.local" ]; then \
		echo "⚠️  No config.local — copy git/config.local.example to config.local and set your identity"; \
	fi
	# Install wt only if missing — keeps `make all` idempotent/offline.
	@if [ ! -x "$(WT_BIN)" ]; then \
		echo "Installing wt $(WT_VERSION)..."; \
		curl -fsSL "$(WT_URL)" -o "$(WT_BIN)" && chmod +x "$(WT_BIN)"; \
	else \
		echo "✅ wt already installed (run 'make git.upgrade' to bump)"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

upgrade:
	@echo "Upgrading $(MODULE_NAME) tools..."
	@mkdir -p $(HOME)/.local/bin
	@echo "Updating wt to $(WT_VERSION)..."
	@curl -fsSL "$(WT_URL)" -o "$(WT_BIN)" && chmod +x "$(WT_BIN)"
	@echo "✅ wt updated to $(WT_VERSION)."
	@$(MAKE) completions

completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@cp $(CURDIR)/completions/_wt $(ZSH_COMPLETIONS_DIR)/_wt
	@echo "✅ wt completions installed."

clean: .remove.xdg.git
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
