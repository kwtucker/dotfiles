include ../env.mk

MODULE_NAME := zsh

.PHONY: install clean

install: .ensure.xdg.zsh
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@curl -sS https://starship.rs/install.sh | sh
	@curl -L git.io/antigen > antigen.zsh
	@ln -sf $(CURDIR)/zshenv $(HOME)/.zshenv
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.zsh
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(HOME)/.zshenv
	@sh -c 'rm "$(command -v 'starship')"'
	@rm ~/.local/bin/antibody
	@echo "✅ $(MODULE_NAME) cleaned."
