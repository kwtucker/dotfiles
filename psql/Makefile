include ../env.mk

MODULE_NAME := psql

.PHONY: install clean

install: .ensure.xdg.psql
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.psql
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
