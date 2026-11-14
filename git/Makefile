include ../env.mk

MODULE_NAME := git

# wt — git worktree manager (POSIX sh). Must run as an executable, NOT be
# sourced: `wt version` self-updates by writing to $0, which would be the
# shell itself when sourced.
# Pinned by default like mise tools — bump WT_VERSION and WT_SHA256 together,
# then `make git.upgrade`. The digest is verified before anything is installed.
WT_VERSION ?= v0.2.2
WT_URL ?= https://codeberg.org/tuck/wt/raw/tag/$(WT_VERSION)/wt.sh
WT_SHA256 ?= abb08d38ffa8f8507abba3e0db68970356749bd3ec9123b4de65e0720ef0dbac
WT_BIN ?= $(HOME)/.local/bin/wt

.PHONY: install clean upgrade completions

install: .ensure.xdg.git
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@if [ ! -f "$(XDG_CONFIG_HOME)/$(MODULE_NAME)/config.local" ]; then \
		echo "⚠️  No config.local — copy git/config.local.example to config.local and set your identity"; \
	fi
	# Install wt only if missing — keeps `make all` idempotent/offline.
	@if [ ! -x "$(WT_BIN)" ]; then \
		echo "Installing wt $(WT_VERSION)..."; \
		mkdir -p "$(HOME)/.local/bin"; \
		"$(DOTFILES_FETCH)" "$(WT_URL)" "$(WT_BIN)" "$(WT_SHA256)" 755 || exit 1; \
	else \
		echo "✅ wt already installed (run 'make git.upgrade' to bump)"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

upgrade:
	@echo "Upgrading $(MODULE_NAME) tools..."
	@mkdir -p $(HOME)/.local/bin
	@echo "Updating wt to $(WT_VERSION)..."
	@"$(DOTFILES_FETCH)" "$(WT_URL)" "$(WT_BIN)" "$(WT_SHA256)" 755
	@echo "✅ wt updated to $(WT_VERSION)."
	@$(MAKE) completions

completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@cp $(CURDIR)/completions/_wt $(ZSH_COMPLETIONS_DIR)/_wt
	@echo "✅ wt completions installed."

clean: .remove.xdg.git
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
