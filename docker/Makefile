include ../env.mk

MODULE_NAME := docker

.PHONY: install clean

install: .ensure.xdg.docker
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@if [ -x "$(HOME)/.rd/bin/docker" ]; then \
		echo "ℹ️  Rancher Desktop docker detected — use 'rd-docker' for its CLI"; \
	else \
		echo "ℹ️  Generic docker client provided via mise (aqua:docker/cli)"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.docker
	@echo "Cleaning $(MODULE_NAME) data..."
	@echo "✅ $(MODULE_NAME) cleaned."