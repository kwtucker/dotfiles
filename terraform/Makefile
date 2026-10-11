include ../env.mk

MODULE_NAME := terraform

.PHONY: install clean completions

install: .ensure.xdg.terraform
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)/plugin-cache
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

# Terraform has no native zsh completion generator — use the maintained
# completion from ohmyzsh (same curl-from-raw.githubusercontent pattern as fzf).
completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@if command -v terraform >/dev/null 2>&1; then \
		echo "Installing terraform completions..."; \
		curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/terraform/_terraform \
			-o $(ZSH_COMPLETIONS_DIR)/_terraform; \
	else \
		echo "⚠️  terraform not installed, skipping completions"; \
	fi

clean: .remove.xdg.terraform
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
