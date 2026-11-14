include ../env.mk

MODULE_NAME := terraform

.PHONY: install clean completions

install: .ensure.xdg.terraform
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)/plugin-cache
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@echo "✅ $(MODULE_NAME) installed."

# Terraform has no native zsh completion generator. The maintained completion
# from ohmyzsh is vendored under completions/ (copied from
# ohmyzsh/ohmyzsh@6010fb6260f359e71d99ba25f05f9215809b3ed2) so installs never
# fetch from a moving branch.
completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@if command -v terraform >/dev/null 2>&1; then \
		echo "Installing terraform completions..."; \
		cp "$(CURDIR)/completions/_terraform" "$(ZSH_COMPLETIONS_DIR)/_terraform"; \
	else \
		echo "⚠️  terraform not installed, skipping completions"; \
	fi

clean: .remove.xdg.terraform
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -f "$(ZSH_COMPLETIONS_DIR)/_terraform"
	@echo "✅ $(MODULE_NAME) cleaned."
