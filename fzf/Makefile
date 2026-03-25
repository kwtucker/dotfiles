include ../env.mk

MODULE_NAME := fzf

.PHONY: install completions clean

install: .ensure.xdg.fzf completions
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

completions:
	@if command -v fzf >/dev/null 2>&1; then \
		echo "Installing fzf completions..."; \
		fzf --zsh > $(ZSH_COMPLETIONS_DIR)/_fzf; \
		curl -sL https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-tmux \
			-o $(HOME)/.local/bin/fzf-tmux && \
		chmod +x $(HOME)/.local/bin/fzf-tmux; \
	else \
		echo "⚠️  fzf not installed, skipping completions"; \
	fi

clean: .remove.xdg.fzf
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
