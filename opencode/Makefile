include ../env.mk

MODULE_NAME := opencode

# opencode itself is declared in the shared mise.toml ([tools."http:opencode"],
# pinned to the v2 line) — this module links the config dir and materialises
# the tool. Keep the version bump in mise.toml, not here.
OPENCODE_TOOL := http:opencode

MISE_DATA := $(or $(MISE_DATA_DIR),$(HOME)/.local/share/mise)

.PHONY: install clean upgrade prune sync-skills

install: .ensure.xdg.opencode
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@echo "🔗 Linked $(CURDIR) -> $(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	@if [ -w "$(MISE_DATA)" ] || [ ! -d "$(MISE_DATA)" ]; then \
		MISE_YES=1 mise install $(OPENCODE_TOOL); \
		mise reshim; \
		mise prune $(OPENCODE_TOOL) || true; \
		mise ls $(OPENCODE_TOOL); \
	else \
		echo "⚠️  $(MISE_DATA) not writable — skipping tool install"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

# Remove superseded opencode versions (keeps the one mise.toml requests).
prune:
	@echo "Pruning old $(MODULE_NAME) versions..."
	@mise prune $(OPENCODE_TOOL) || true
	@mise ls $(OPENCODE_TOOL)

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

# Compatibility alias: shared skills now belong to the agents module.
SKILL_SYNC_ARGS ?=

sync-skills:
	@$(MAKE) -C ../agents sync-skills SKILL_SYNC_ARGS="$(SKILL_SYNC_ARGS)"
