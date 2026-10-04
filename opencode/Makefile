include ../env.mk

MODULE_NAME := opencode

OPENCODE_VERSION ?= latest

MISE_CONFD := $(XDG_CONFIG_HOME)/mise/conf.d
MISE_DATA := $(or $(MISE_DATA_DIR),$(HOME)/.local/share/mise)

.PHONY: install clean upgrade sync-skills

install: .ensure.xdg.opencode
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@if [ -d "$(XDG_CONFIG_HOME)/$(MODULE_NAME)" ] && [ ! -L "$(XDG_CONFIG_HOME)/$(MODULE_NAME)" ]; then \
		echo "⚠️  Removing existing directory $(XDG_CONFIG_HOME)/$(MODULE_NAME)"; \
		rm -rf "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"; \
	fi
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "🔗 Linked $(CURDIR) -> $(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@mkdir -p $(MISE_CONFD)
	@MISE_YES=1 mise trust $(MISE_CONFD)/opencode.toml 2>/dev/null || true
