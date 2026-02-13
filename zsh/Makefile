include ../env.mk

MODULE_NAME := zsh

.PHONY: set-default-shell install clean

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
		chsh -s "$$zsh_path"; \
	else \
		echo "✅ Default shell already zsh"; \
	fi

install: .ensure.xdg.zsh
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@curl -sS https://starship.rs/install.sh | sh
	@curl -L git.io/antigen > antigen.zsh
	@ln -sf $(CURDIR)/zshenv $(HOME)/.zshenv
	@$(MAKE) set-default-shell
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.zsh
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(HOME)/.zshenv
	@sh -c 'rm "$(command -v 'starship')"'
	@rm ~/.local/bin/antibody
	@echo "✅ $(MODULE_NAME) cleaned."
