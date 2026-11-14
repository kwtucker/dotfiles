include ../env.mk

MODULE_NAME := sops
AGE_DIR := $(XDG_CONFIG_HOME)/age
SOPS_HELPER := $(HOME)/.local/bin/sops-age-key-from-wbs

.PHONY: install clean

install: .ensure.xdg.sops
	@echo "Installing $(MODULE_NAME)..."
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@mkdir -p $(AGE_DIR)
	@mkdir -p $(HOME)/.local/bin
	@chmod 700 $(AGE_DIR)
	@if [ ! -x "$(SOPS_HELPER)" ] || grep -q '^# managed by the dotfiles sops module$$' "$(SOPS_HELPER)" 2>/dev/null || { grep -q 'WBS_IDENTITY' "$(SOPS_HELPER)" 2>/dev/null && grep -q '^exec age -d ' "$(SOPS_HELPER)" 2>/dev/null; }; then \
		echo "Installing sops-age-key helper..."; \
		printf '%s\n' '#!/usr/bin/env bash' '# managed by the dotfiles sops module' 'IDENTITY="$${WBS_IDENTITY:-$(AGE_DIR)/wbs-identity.age}"' 'exec age -d "$$IDENTITY"' > "$(SOPS_HELPER)"; \
		chmod +x "$(SOPS_HELPER)"; \
	else \
		echo "✅ sops-age-key-from-wbs already installed (custom helper left untouched)"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.sops
	@if [ -f "$(SOPS_HELPER)" ] && { grep -q '^# managed by the dotfiles sops module$$' "$(SOPS_HELPER)" 2>/dev/null || { grep -q 'WBS_IDENTITY' "$(SOPS_HELPER)" 2>/dev/null && grep -q '^exec age -d ' "$(SOPS_HELPER)" 2>/dev/null; }; }; then \
		rm -f "$(SOPS_HELPER)"; \
		echo "Removed $(SOPS_HELPER)."; \
	fi
	@echo "✅ $(MODULE_NAME) cleaned."
