include ../env.mk

MODULE_NAME := tmux
TPM_DIR := $(HOME)/.tmux/plugins/tpm

.PHONY: install clean

install: .ensure.xdg.tmux
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(HOME)/.tmux/plugins
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	# Install or update TPM
	@if [ ! -d "$(TPM_DIR)/.git" ]; then \
		echo "📥 Cloning TPM..."; \
		git clone https://github.com/tmux-plugins/tpm "$(TPM_DIR)"; \
	else \
		echo "🔄 Updating TPM..."; \
		git -C "$(TPM_DIR)" pull --ff-only; \
	fi
	# Install plugins if tmux is running
	@if command -v tmux >/dev/null && tmux info >/dev/null 2>&1; then \
			echo "🔌 Installing tmux plugins via TPM..."; \
			"$(TPM_DIR)/scripts/install_plugins.sh"; \
			tmux source-file "$(XDG_CONFIG_HOME)/tmux/tmux.conf"; \
	else \
			echo "ℹ️ tmux not running — skipping plugin install"; \
	fi
	@"$(TPM_DIR)/scripts/install_plugins.sh" || true
	tmux source-file $(XDG_CONFIG_HOME)/tmux/tmux.conf
	@echo "✅ $(MODULE_NAME) installed."


clean: .remove.xdg.tmux
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(HOME)/.tmux/plugins
	@echo "✅ $(MODULE_NAME) cleaned."
