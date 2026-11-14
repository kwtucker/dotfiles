include ../env.mk

MODULE_NAME := fzf

# fzf-tmux is fetched from the fzf release matching the mise pin in mise.toml.
# Bump FZF_TMUX_VERSION and FZF_TMUX_SHA256 together.
FZF_TMUX_VERSION := v0.74.4
FZF_TMUX_URL := https://raw.githubusercontent.com/junegunn/fzf/$(FZF_TMUX_VERSION)/bin/fzf-tmux
FZF_TMUX_SHA256 := ea14943d739fc81952d5071a642591df25ed8dac166040a6d6036b3be197cecd

.PHONY: install completions clean

install: .ensure.xdg.fzf
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@echo "✅ $(MODULE_NAME) installed."

completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@# NOTE: `fzf --zsh` is a shell integration script (key bindings + widgets)
	@# meant to be sourced — it is NOT a `_fzf` completion function, so it must
	@# never be dumped into the completions dir. Remove any stale bogus copy.
	@rm -f $(ZSH_COMPLETIONS_DIR)/_fzf
	@if command -v fzf >/dev/null 2>&1; then \
		echo "Installing fzf helpers..."; \
		mkdir -p "$(HOME)/.local/bin"; \
		"$(DOTFILES_FETCH)" "$(FZF_TMUX_URL)" "$(HOME)/.local/bin/fzf-tmux" "$(FZF_TMUX_SHA256)" 755; \
	else \
		echo "⚠️  fzf not installed, skipping helpers"; \
	fi

clean: .remove.xdg.fzf
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -f "$(HOME)/.local/bin/fzf-tmux" "$(ZSH_COMPLETIONS_DIR)/_fzf"
	@echo "✅ $(MODULE_NAME) cleaned."
