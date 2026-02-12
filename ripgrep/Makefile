include ../env.mk

MODULE_NAME := ripgrep

.PHONY: install clean

install: .ensure.xdg.ripgrep
	@echo "Installing $(MODULE_NAME) dotfiles..."
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.ripgrep
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
