include ../env.mk

MODULE_NAME := helm

.PHONY: install completions clean

install: .ensure.xdg.helm
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

completions:
	@if command -v helm >/dev/null 2>&1; then \
		echo "Installing helm completions..."; \
		helm completion zsh > $(ZSH_COMPLETIONS_DIR)/_helm; \
	else \
		echo "⚠️  helm not installed, skipping completions"; \
	fi

clean: .remove.xdg.helm
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."