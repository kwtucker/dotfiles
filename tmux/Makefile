include ../env.mk

MODULE_NAME := tmux
TPM_DIR := $(HOME)/.tmux/plugins/tpm

.PHONY: install clean

install: .ensure.xdg.tmux
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(HOME)/.tmux/plugins
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@if [ ! -d "$(TPM_DIR)" ]; then \
	  git clone https://github.com/tmux-plugins/tpm "$(TPM_DIR)"; \
	fi
	mkdir -p $(XDG_CONFIG_HOME)/tmux/plugins/catppuccin
	git clone -b v2.1.3 https://github.com/catppuccin/tmux.git $(XDG_CONFIG_HOME)/tmux/plugins/catppuccin/tmux
	@"$(TPM_DIR)/scripts/install_plugins.sh" || true
	tmux source-file $(XDG_CONFIG_HOME)/tmux/tmux.conf
	@echo "✅ $(MODULE_NAME) installed."


clean: .remove.xdg.tmux
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(HOME)/.tmux/plugins
	@echo "✅ $(MODULE_NAME) cleaned."
