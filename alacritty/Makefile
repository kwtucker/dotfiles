include ../env.mk

MODULE_NAME := alacritty

.PHONY: install clean

install: .ensure.xdg.alacritty
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.alacritty
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
