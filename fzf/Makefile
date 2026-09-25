include ../env.mk

MODULE_NAME := fzf

.PHONY: install completions clean

install: .ensure.xdg.fzf
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@# NOTE: `fzf --zsh` is a shell integration script (key bindings + widgets)
	@# meant to be sourced — it is NOT a `_fzf` completion function, so it must
	@# never be dumped into the completions dir. Remove any stale bogus copy.
	@rm -f $(ZSH_COMPLETIONS_DIR)/_fzf
	@if command -v fzf >/dev/null 2>&1; then \
		echo "Installing fzf helpers..."; \
		curl -fsSL https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-tmux \
			-o $(HOME)/.local/bin/fzf-tmux && \
		chmod +x $(HOME)/.local/bin/fzf-tmux; \
	else \
		echo "⚠️  fzf not installed, skipping helpers"; \
	fi

clean: .remove.xdg.fzf
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."
