include ../env.mk

MODULE_NAME := ripgrep

.PHONY: install clean completions

install: .ensure.xdg.ripgrep completions
	@echo "Installing $(MODULE_NAME) dotfiles..."
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

completions:
	@if command -v rg >/dev/null 2>&1; then \
		echo "Installing ripgrep completions..."; \
		rg --generate=complete-zsh > $(ZSH_COMPLETIONS_DIR)/_helm; \
	else \
		echo "⚠️  ripgrep not installed, skipping completions"; \
	fi

clean: .remove.xdg.ripgrep
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
