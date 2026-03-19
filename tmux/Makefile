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
	# Install plugins non-interactively using a temporary tmux session
	@if command -v tmux >/dev/null 2>&1; then \
		echo "🔌 Installing tmux plugins via TPM (non-interactive)..."; \
		TMP_SESSION="tmp-tpm-install-$$RANDOM"; \
		tmux new-session -d -s "$$TMP_SESSION"; \
		tmux source-file "$(XDG_CONFIG_HOME)/tmux/tmux.conf" -t "$$TMP_SESSION"; \
		"$(TPM_DIR)/scripts/install_plugins.sh" -t "$$TMP_SESSION"; \
		tmux kill-session -t "$$TMP_SESSION"; \
	else \
		echo "ℹ️ tmux not installed — skipping plugin install"; \
	fi
	# Install plugins if tmux is running
	# @if command -v tmux >/dev/null && tmux info >/dev/null 2>&1; then \
	# 		echo "🔌 Installing tmux plugins via TPM..."; \
	# 		"$(TPM_DIR)/scripts/install_plugins.sh"; \
	# 		tmux source-file "$(XDG_CONFIG_HOME)/tmux/tmux.conf"; \
	# else \
	# 		echo "ℹ️ tmux not running — skipping plugin install"; \
	# fi

	@echo "✅ $(MODULE_NAME) installed."


clean: .remove.xdg.tmux
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(HOME)/.tmux/plugins
	@echo "✅ $(MODULE_NAME) cleaned."
