include ../env.mk

MODULE_NAME := git

.PHONY: install clean

install: .ensure.xdg.git
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@if [ ! -f "$(XDG_CONFIG_HOME)/$(MODULE_NAME)/config.local" ]; then \
		echo "⚠️  No config.local — copy git/config.local.example to config.local and set your identity"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.git
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
