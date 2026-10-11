include ../env.mk

MODULE_NAME := docker

.PHONY: install clean completions

install: .ensure.xdg.docker
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@if [ -x "$(HOME)/.rd/bin/docker" ]; then \
		echo "ℹ️  Rancher Desktop docker detected — use 'rd-docker' for its CLI"; \
	else \
		echo "ℹ️  Generic docker client provided via mise (aqua:docker/cli)"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

completions:
	@mkdir -p $(ZSH_COMPLETIONS_DIR)
	@if command -v docker >/dev/null 2>&1; then \
		echo "Installing docker completions..."; \
		docker completion zsh > $(ZSH_COMPLETIONS_DIR)/_docker; \
	else \
		echo "⚠️  docker not installed, skipping completions"; \
	fi

clean: .remove.xdg.docker
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."