include ../env.mk

MODULE_NAME := rust

.PHONY: install clean completions

install: .ensure.xdg.rust
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@if command -v rustup >/dev/null 2>&1; then \
		echo "Installing rustup completions..."; \
		rustup completions zsh > $(ZSH_COMPLETIONS_DIR)/_rustup; \
		if command -v rustc >/dev/null 2>&1; then \
			echo "Installing cargo completions..."; \
			rustup completions zsh cargo > $(ZSH_COMPLETIONS_DIR)/_cargo; \
		fi; \
	else \
		echo "⚠️  rustup not installed, skipping completions"; \
	fi

clean: .remove.xdg.rust
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."