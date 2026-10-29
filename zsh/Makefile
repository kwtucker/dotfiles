include ../env.mk

MODULE_NAME := zsh
ZSH_DIR := $(XDG_CONFIG_HOME)/$(MODULE_NAME)
LOCAL_BIN := $(HOME)/.local/bin

.PHONY: install clean upgrade regen-cache completions

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
	# Remove existing directory if it's not a symlink
	@if [ -d "$(ZSH_DIR)" ] && [ ! -L "$(ZSH_DIR)" ]; then \
		echo "⚠️  Removing existing directory $(ZSH_DIR)"; \
		rm -rf "$(ZSH_DIR)"; \
	fi
	# Create symlink
	@ln -sfn $(CURDIR) $(ZSH_DIR)
	@echo "🔗 Linked $(CURDIR) -> $(ZSH_DIR)"
	# Ensure local bin exists
	@mkdir -p $(LOCAL_BIN)
	# Install Antigen only if missing — keeps the tracked pin stable so
	# installs never dirty the repo. Use `make zsh.upgrade` to bump it.
	@[ -f $(ZSH_DIR)/antigen.zsh ] || { \
		echo "Fetching antigen..."; \
		curl -fsSL git.io/antigen -o $(ZSH_DIR)/antigen.zsh; \
	}
	# Link zshenv
	@ln -sf $(CURDIR)/zshenv $(HOME)/.zshenv
	# Set default shell (optional)
	# @$(MAKE) set-default-shell
	@echo "✅ $(MODULE_NAME) installed."

# Shell-tooling completions (mise, uv, ruff, starship, gh, lazygit,
# terraform-docs) — grouped here since they don't have dedicated modules.
completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@if command -v mise >/dev/null 2>&1; then \
		echo "Installing mise completions..."; \
		mise completions zsh > $(ZSH_COMPLETIONS_DIR)/_mise; \
	else \
		echo "⚠️  mise not installed, skipping completions"; \
	fi
	@if command -v uv >/dev/null 2>&1; then \
		echo "Installing uv completions..."; \
		uv generate-shell-completion zsh > $(ZSH_COMPLETIONS_DIR)/_uv; \
	else \
		echo "⚠️  uv not installed, skipping completions"; \
	fi
	@if command -v ruff >/dev/null 2>&1; then \
		echo "Installing ruff completions..."; \
		ruff generate-shell-completion zsh > $(ZSH_COMPLETIONS_DIR)/_ruff; \
	else \
		echo "⚠️  ruff not installed, skipping completions"; \
	fi
	@if command -v starship >/dev/null 2>&1; then \
		echo "Installing starship completions..."; \
		starship completions zsh > $(ZSH_COMPLETIONS_DIR)/_starship; \
	else \
		echo "⚠️  starship not installed, skipping completions"; \
	fi
	@if command -v gh >/dev/null 2>&1; then \
		echo "Installing gh completions..."; \
		gh completion -s zsh > $(ZSH_COMPLETIONS_DIR)/_gh; \
	else \
		echo "⚠️  gh not installed, skipping completions"; \
	fi
	@if command -v lazygit >/dev/null 2>&1; then \
		echo "Installing lazygit completions..."; \
		lazygit completion zsh > $(ZSH_COMPLETIONS_DIR)/_lazygit; \
	else \
		echo "⚠️  lazygit not installed, skipping completions"; \
	fi
	@if command -v terraform-docs >/dev/null 2>&1; then \
		echo "Installing terraform-docs completions..."; \
		terraform-docs completion zsh > $(ZSH_COMPLETIONS_DIR)/_terraform-docs; \
	else \
		echo "⚠️  terraform-docs not installed, skipping completions"; \
	fi

upgrade:
	@echo "Upgrading $(MODULE_NAME) plugins..."
	@curl -fsSL git.io/antigen -o $(ZSH_DIR)/antigen.zsh
	@rm -f "$${ADOTDIR:-$$HOME/.antigen}/.lock"
	@zsh -ic 'antigen update'
	# Rebuild in a fresh non-interactive shell: applying again in the update
	# shell can generate an empty cache and silently disable every plugin.
	@$(MAKE) regen-cache
	@echo "✅ $(MODULE_NAME) upgraded."

# Regenerate the antigen plugin cache. MUST run non-interactively
# (_ANTIGEN_INTERACTIVE=false) so antigen captures bundle sources —
# `antigen cache-gen` from an interactive shell writes an EMPTY cache,
# silently disabling every plugin (fzf-tab, autosuggestions, ...).
# Run this on the machine where the shell will be used: WORKSPACE_IMAGE
# gates laptop-only bundles (e.g. git-open) at generation time.
regen-cache:
	@echo "Regenerating antigen cache..."
	@rm -f "$${ADOTDIR:-$$HOME/.antigen}/init.zsh" "$${ADOTDIR:-$$HOME/.antigen}/init.zsh.zwc"
	@zsh -c '_ANTIGEN_INTERACTIVE=false; source $(ZSH_DIR)/.zshrc'
	@grep -q "fzf-tab/fzf-tab.plugin.zsh" "$${ADOTDIR:-$$HOME/.antigen}/init.zsh" \
		&& echo "✅ antigen cache regenerated." \
		|| (echo "❌ cache regen failed (fzf-tab missing from cache)"; exit 1)

clean: .remove.xdg.zsh
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -f $(HOME)/.zshenv
	@rm -f $(ZSH_DIR)/antigen.zsh
	@echo "✅ $(MODULE_NAME) cleaned."
