include ../env.mk

MODULE_NAME := sops
AGE_DIR := $(XDG_CONFIG_HOME)/age

.PHONY: install clean

install: .ensure.xdg.sops
	@echo "Installing $(MODULE_NAME)..."
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@mkdir -p $(AGE_DIR)
	@mkdir -p $(HOME)/.local/bin
	@chmod 700 $(AGE_DIR)
	@if [ ! -x "$(HOME)/.local/bin/sops-age-key-from-wbs" ]; then \
		echo "Installing sops-age-key helper..."; \
		printf '%s\n' '#!/usr/bin/env bash' 'IDENTITY="$${WBS_IDENTITY:-$(AGE_DIR)/wbs-identity.age}"' 'exec age -d "$$IDENTITY"' > $(HOME)/.local/bin/sops-age-key-from-wbs; \
		chmod +x $(HOME)/.local/bin/sops-age-key-from-wbs; \
	else \
		echo "✅ sops-age-key-from-wbs already installed"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.sops
	@rm -f $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) cleaned."
