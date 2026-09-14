include ../env.mk

MODULE_NAME := nvim

.PHONY: install clean

install: .ensure.xdg.nvim
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.nvim
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf ~/.local/state/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) cleaned."
