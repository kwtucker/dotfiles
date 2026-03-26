include ../env.mk
 
MODULE_NAME := yazi
 
.PHONY: install clean
 
install: .ensure.xdg.yazi
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."
 
clean: .remove.xdg.yazi
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
