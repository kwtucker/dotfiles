include ../env.mk

MODULE_NAME := fzf
FZF_DIR := fzf

.PHONY: install clean

install: .ensure.xdg.fzf
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@if [ ! -d "$(FZF_DIR)/.git" ]; then \
		echo "📥 Cloning fzf..."; \
		git clone --depth 1 https://github.com/junegunn/fzf.git "$(FZF_DIR)"; \
	else \
		echo "🔄 Updating fzf..."; \
		git -C "$(FZF_DIR)" pull --ff-only; \
	fi
	@"$(FZF_DIR)/install" --all --xdg --no-update-rc --no-bash --no-fish
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.fzf
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf "$(FZF_DIR)"
	@echo "✅ $(MODULE_NAME) cleaned."
