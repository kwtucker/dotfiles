include ../env.mk

MODULE_NAME := whalebyte

.PHONY: install clean

install: .ensure.xdg.whalebyte
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@mkdir -p ~/.whalebyte/code
	@touch ~/.whalebyte/.env ~/.whalebyte/.secret
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.whalebyte
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
