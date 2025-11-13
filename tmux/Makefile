XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_RUNTIME_DIR ?= $(HOME)/.local/run

MODULE_NAME := tmux
TPM_DIR := $(HOME)/.tmux/plugins/tpm

.PHONY: install clean

install:
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(HOME)/.tmux/plugins
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_DATA_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@if [ ! -d "$(TPM_DIR)" ]; then \
	  git clone https://github.com/tmux-plugins/tpm "$(TPM_DIR)"; \
	fi
	@"$(TPM_DIR)/scripts/install_plugins.sh" || true
	tmux source-file $(XDG_CONFIG_HOME)/tmux/tmux.conf
	./scripts/kubenv.sh
	@echo "✅ $(MODULE_NAME) installed."


clean:
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_DATA_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@rm -rf $(HOME)/.tmux/plugins
	@echo "✅ $(MODULE_NAME) cleaned."
