include ../env.mk

MODULE_NAME := opencode

# Version is declared once here; install writes it into a machine-local
# mise fragment (~/.config/mise/conf.d/opencode.toml) so the binary stays
# out of the shared mise.toml.
OPENCODE_VERSION ?= latest

MISE_CONFD := $(XDG_CONFIG_HOME)/mise/conf.d
MISE_DATA := $(or $(MISE_DATA_DIR),$(HOME)/.local/share/mise)

.PHONY: install clean upgrade

install: .ensure.xdg.opencode
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@if [ -d "$(XDG_CONFIG_HOME)/$(MODULE_NAME)" ] && [ ! -L "$(XDG_CONFIG_HOME)/$(MODULE_NAME)" ]; then \
		echo "⚠️  Removing existing directory $(XDG_CONFIG_HOME)/$(MODULE_NAME)"; \
		rm -rf "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"; \
	fi
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "🔗 Linked $(CURDIR) -> $(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@mkdir -p $(MISE_CONFD)
	@printf '[tools]\n"aqua:anomalyco/opencode" = "$(OPENCODE_VERSION)"\n' > $(MISE_CONFD)/opencode.toml
	@MISE_YES=1 mise trust $(MISE_CONFD)/opencode.toml
	@if [ -w "$(MISE_DATA)" ] || [ ! -d "$(MISE_DATA)" ]; then \
		mise install; \
	else \
		echo "⚠️  $(MISE_DATA) not writable — skipping tool install"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

upgrade:
	@MISE_YES=1 mise upgrade "aqua:anomalyco/opencode"

clean: .remove.xdg.opencode
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -f $(MISE_CONFD)/opencode.toml
	@mise uninstall "aqua:anomalyco/opencode" || true
	@echo "✅ $(MODULE_NAME) cleaned."
