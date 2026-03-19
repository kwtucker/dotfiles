include ../env.mk

MODULE_NAME := zsh
ZSH_DIR := $(XDG_CONFIG_HOME)/$(MODULE_NAME)
LOCAL_BIN := $(HOME)/.local/bin

.PHONY: set-default-shell install clean

# Optional: set default shell (may fail in DevPod/containers)
set-default-shell:
	@current_shell="$$( \
		if command -v dscl >/dev/null 2>&1; then \
			dscl . -read /Users/$$USER UserShell | awk '{print $$2}'; \
		else \
			getent passwd $$USER | cut -d: -f7; \
		fi \
	)"; \
	zsh_path="$$(command -v zsh)"; \
	if [ "$$current_shell" != "$$zsh_path" ]; then \
		echo "🔁 Setting default shell to zsh ($$zsh_path)"; \
		chsh -s "$$zsh_path" || echo "⚠️  Could not change shell (permission denied)"; \
	else \
		echo "✅ Default shell already zsh"; \
	fi

install: .ensure.xdg.zsh
	@echo "Installing $(MODULE_NAME) dotfiles..."
	# Link module to XDG config if not already linked
	@if [ ! -L "$(ZSH_DIR)" ]; then \
		ln -sfn $(CURDIR) $(ZSH_DIR); \
		echo "🔗 Linked $(CURDIR) -> $(ZSH_DIR)"; \
	else \
		echo "✅ $(ZSH_DIR) already linked"; \
	fi
	# Ensure local bin exists
	@mkdir -p $(LOCAL_BIN)
	@curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir $(LOCAL_BIN)
	@curl -L git.io/antigen -o $(ZSH_DIR)/antigen.zsh
	@ln -sf $(CURDIR)/zshenv $(HOME)/.zshenv
	# Set default shell (optional)
	@$(MAKE) set-default-shell
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.zsh
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -f $(HOME)/.zshenv
	@rm -f $(LOCAL_BIN)/starship
	@rm -f $(ZSH_DIR)/antigen.zsh
	@echo "✅ $(MODULE_NAME) cleaned."
