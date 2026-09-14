include ../env.mk

MODULE_NAME := kubernetes

.PHONY: install completions clean

install: .ensure.xdg.kubernetes
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

completions:
	@if command -v kubectl >/dev/null 2>&1; then \
		echo "Installing kubectl completions..."; \
		kubectl completion zsh > $(ZSH_COMPLETIONS_DIR)/_kubectl; \
	else \
		echo "⚠️  kubectl not installed, skipping completions"; \
	fi

clean: .remove.xdg.kubernetes
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."