include ../env.mk

MODULE_NAME := tmux
TMUX_DIR := $(XDG_CONFIG_HOME)/$(MODULE_NAME)
TPM_DIR := $(HOME)/.tmux/plugins/tpm

.PHONY: install clean

install: .ensure.xdg.tmux
	@echo "Installing $(MODULE_NAME) dotfiles..."
	# Link tmux config dir
	@if [ ! -L "$(TMUX_DIR)" ]; then \
		ln -sfn $(CURDIR) $(TMUX_DIR); \
		echo "Linked $(CURDIR) -> $(TMUX_DIR)"; \
	else \
		echo "✅ $(TMUX_DIR) already linked"; \
	fi
	# Install or update TPM
	@mkdir -p $(HOME)/.tmux/plugins
	@if [ ! -d "$(TPM_DIR)/.git" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$(TPM_DIR)"; \
	else \
		git -C "$(TPM_DIR)" pull --ff-only; \
	fi
	# Install plugins non-interactively if tmux server is running
	@if command -v tmux >/dev/null && tmux info >/dev/null 2>&1; then \
		"$(TPM_DIR)/scripts/install_plugins.sh"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.tmux
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(TPM_DIR)
	@echo "✅ $(MODULE_NAME) cleaned."
