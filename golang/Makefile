include ../env.mk

MODULE_NAME := golang

.PHONY: install clean completions

install: .ensure.xdg.golang
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@if command -v golangci-lint >/dev/null 2>&1; then \
		echo "Installing golangci-lint completions..."; \
		golangci-lint completion zsh > $(ZSH_COMPLETIONS_DIR)/_golangci-lint; \
	else \
		echo "⚠️  golangci-lint not installed, skipping completions"; \
	fi

clean: .remove.xdg.golang
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."