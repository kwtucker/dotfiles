include ../env.mk

MODULE_NAME := sops

.PHONY: install clean

install: .ensure.xdg.sops
	@echo "Installing $(MODULE_NAME)..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@mkdir -p $(HOME)/.config/sops/age
	@mkdir -p $(HOME)/.config/age
	@mkdir -p $(HOME)/.local/bin
	@chmod 700 $(HOME)/.config/sops
	@chmod 700 $(HOME)/.config/age
	@printf '%s\n' '#!/usr/bin/env bash' 'IDENTITY="$${WBS_IDENTITY:-$$HOME/.config/age/wbs-identity.age}"' 'exec age -d "$$IDENTITY"' > $(HOME)/.local/bin/sops-age-key-from-wbs
	@chmod +x $(HOME)/.local/bin/sops-age-key-from-wbs
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.sops
	@rm -f $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) cleaned."
