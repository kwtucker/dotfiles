include ../env.mk

MODULE_NAME := nvim

.PHONY: install clean

install: .ensure.xdg.nvim
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@rm -rf ~/.local/state/$(MODULE_NAME)
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.nvim
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
