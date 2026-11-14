include ../env.mk

MODULE_NAME := tmux
TMUX_DIR := $(XDG_CONFIG_HOME)/$(MODULE_NAME)
TPM_DIR := $(HOME)/.tmux/plugins/tpm

# TPM is pinned to a release tag and verified after clone/checkout. Plugin
# updates still come from TPM itself; bump TPM_VERSION and TPM_COMMIT together
# (the commit makes a force-moved tag visible instead of silently accepted).
TPM_VERSION := v3.1.0
TPM_COMMIT := 7bdb7ca33c9cc6440a600202b50142f401b6fe21
TPM_URL := https://github.com/tmux-plugins/tpm

.PHONY: install clean upgrade .tpm.pin

# Clone or move TPM to the pinned tag, then require the recorded commit.
.tpm.pin:
	@mkdir -p "$(HOME)/.tmux/plugins"
	@if [ ! -d "$(TPM_DIR)/.git" ]; then \
		echo "Cloning TPM $(TPM_VERSION)..."; \
		git clone --quiet --branch "$(TPM_VERSION)" --depth 1 "$(TPM_URL)" "$(TPM_DIR)" || exit 1; \
	fi
	@actual="$$(git -C "$(TPM_DIR)" rev-parse HEAD 2>/dev/null || true)"; \
	if [ "$$actual" != "$(TPM_COMMIT)" ]; then \
		echo "Pinning TPM to $(TPM_VERSION)..."; \
		git -C "$(TPM_DIR)" fetch --quiet --tags --force origin || exit 1; \
		git -C "$(TPM_DIR)" checkout --quiet "$(TPM_VERSION)" || exit 1; \
	fi; \
	actual="$$(git -C "$(TPM_DIR)" rev-parse HEAD 2>/dev/null || true)"; \
	[ "$$actual" = "$(TPM_COMMIT)" ] || { \
		echo "❌ TPM HEAD $$actual does not match pinned $(TPM_COMMIT)"; exit 1; \
	}

install: .ensure.xdg.tmux .tpm.pin
	@echo "Installing $(MODULE_NAME) dotfiles..."
	# The helper repairs links left behind by a moved/renamed checkout and
	# refuses real directories unless DOTFILES_ADOPT=1 is set.
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(TMUX_DIR)"
	# Updates happen via `make tmux.upgrade` (pulling TPM on every install added
	# a needless network round-trip).
	# Install plugins non-interactively if tmux server is running
	@if command -v tmux >/dev/null && tmux info >/dev/null 2>&1; then \
		"$(TPM_DIR)/scripts/install_plugins.sh"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

upgrade: .tpm.pin
	@echo "Upgrading $(MODULE_NAME) plugins..."
	@# Some plugins (notably catppuccin/tmux) force-move floating tags
	@# (`latest`, `v2`) on every release. TPM updates via plain `git pull`,
	@# which can never overwrite a locally-clobbered tag — re-running the
	@# upgrade fails identically every time. Force-update tags first so the
	@# pull below always succeeds. Safe: TPM tracks branches, not tags.
	@for d in $(HOME)/.tmux/plugins/*/; do \
		if [ -d "$$d/.git" ]; then \
			git -C "$$d" fetch origin --tags --force --quiet 2>/dev/null || true; \
		fi; \
	done
	@if [ -x "$(TPM_DIR)/bin/update_plugins" ]; then \
		"$(TPM_DIR)/bin/update_plugins" all; \
	elif [ -x "$(TPM_DIR)/scripts/install_plugins.sh" ]; then \
		"$(TPM_DIR)/scripts/install_plugins.sh"; \
	else \
		echo "⚠️  TPM update script not found, skipping plugin update"; \
	fi
	@echo "✅ $(MODULE_NAME) upgraded."

clean: .remove.xdg.tmux
	@echo "Cleaning $(MODULE_NAME) data..."
	@if [ -d "$(TPM_DIR)/.git" ] && [ "$$(git -C "$(TPM_DIR)" remote get-url origin 2>/dev/null || true)" = "$(TPM_URL)" ]; then \
		rm -rf "$(TPM_DIR)"; \
	fi
	@echo "✅ $(MODULE_NAME) cleaned."
