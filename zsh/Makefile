XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_RUNTIME_DIR ?= $(HOME)/.local/run

MODULE_NAME := zsh

.PHONY: install clean

install:
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_DATA_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@curl -sS https://starship.rs/install.sh | sh
	@curl -L git.io/antigen > antigen.zsh
	@ln -sf $(CURDIR)/zshenv $(HOME)/.zshenv
	@echo "✅ $(MODULE_NAME) installed."

clean:
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_DATA_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@rm -rf $(HOME)/.zshenv
	@sh -c 'rm "$(command -v 'starship')"'
	@rm ~/.local/bin/antibody
	@echo "✅ $(MODULE_NAME) cleaned."
