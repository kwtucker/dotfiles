include ../env.mk

MODULE_NAME := tmux
TMUX_DIR := $(XDG_CONFIG_HOME)/$(MODULE_NAME)
TPM_DIR := $(HOME)/.tmux/plugins/tpm

.PHONY: install clean upgrade

install: .ensure.xdg.tmux
	@echo "Installing $(MODULE_NAME) dotfiles..."
	# Link tmux config dir
	@if [ ! -L "$(TMUX_DIR)" ]; then \
		ln -sfn $(CURDIR) $(TMUX_DIR); \
		echo "Linked $(CURDIR) -> $(TMUX_DIR)"; \
	else \
		echo "✅ $(TMUX_DIR) already linked"; \
	fi
	# Install or update TPM
	@mkdir -p $(HOME)/.tmux/plugins
	@if [ ! -d "$(TPM_DIR)/.git" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$(TPM_DIR)"; \
	else \
		git -C "$(TPM_DIR)" pull --ff-only; \
	fi
	# Install plugins non-interactively if tmux server is running
	@if command -v tmux >/dev/null && tmux info >/dev/null 2>&1; then \
		"$(TPM_DIR)/scripts/install_plugins.sh"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

upgrade:
	@echo "Upgrading $(MODULE_NAME) plugins..."
	@mkdir -p $(HOME)/.tmux/plugins
	@if [ ! -d "$(TPM_DIR)/.git" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$(TPM_DIR)"; \
	else \
		git -C "$(TPM_DIR)" pull --ff-only; \
	fi
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
	@rm -rf $(TPM_DIR)
	@echo "✅ $(MODULE_NAME) cleaned."
