include ../env.mk

MODULE_NAME := opencode

# opencode itself is declared in the shared mise.toml ([tools."http:opencode"],
# pinned to the v2 line) — this module links the config dir and materialises
# the tool. Keep the version bump in mise.toml, not here.
OPENCODE_TOOL := http:opencode

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
	@if [ -w "$(MISE_DATA)" ] || [ ! -d "$(MISE_DATA)" ]; then \
		MISE_YES=1 mise install $(OPENCODE_TOOL); \
		mise reshim; \
		mise ls $(OPENCODE_TOOL); \
	else \
		echo "⚠️  $(MISE_DATA) not writable — skipping tool install"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

upgrade:
	@echo "Upgrading $(MODULE_NAME)..."
	@MISE_YES=1 mise upgrade $(OPENCODE_TOOL)
	@mise reshim
	@mise ls $(OPENCODE_TOOL)
	@echo "✅ $(MODULE_NAME) upgraded."

clean: .remove.xdg.opencode
	@echo "Cleaning $(MODULE_NAME) data..."
	@mise uninstall $(OPENCODE_TOOL) || true
	@echo "✅ $(MODULE_NAME) cleaned."

# Re-vendor the conventional-commits skill from upstream claude-kit.
# Pass a pinned commit with: make -C opencode sync-skills SKILL_SYNC_ARGS="--sha <sha>"
SKILL_SYNC_ARGS ?=

sync-skills:
	@./skills/conventional-commits/sync.sh $(SKILL_SYNC_ARGS)
