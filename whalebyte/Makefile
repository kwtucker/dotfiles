include ../env.mk

MODULE_NAME := whalebyte
WHALEBYTE_DIR := $(HOME)/.whalebyte
LOCAL_BIN := $(HOME)/.local/bin

.PHONY: install clean

install: .ensure.xdg.whalebyte
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(XDG_CONFIG_HOME)/$(MODULE_NAME)"
	# Local data dir. The encrypted vault (~/.whalebyte/.secret) may already
	# exist — never create or truncate it here, and keep the dir private.
	@mkdir -p $(WHALEBYTE_DIR)/code
	@chmod 700 $(WHALEBYTE_DIR)
	@touch $(WHALEBYTE_DIR)/.env
	# wbs — the secrets-vault CLI. Symlinked (not sourced) so updates to the
	# tracked script take effect immediately. See whalebyte/README.md.
	# ~/.local/bin is created by the bin/zsh modules (as git's `wt` relies on).
	@mkdir -p $(XDG_CONFIG_HOME)/age
	@chmod 700 $(XDG_CONFIG_HOME)/age
	@$(DOTFILES_LINK) link_file "$(CURDIR)/bin/wbs" "$(LOCAL_BIN)/wbs"
	# Dependencies come from mise (age, jq); nvim is only needed to edit.
	@if ! command -v age >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then \
		echo "⚠️  wbs needs 'age' and 'jq' on PATH — run 'mise install' (or './install')"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.whalebyte
	@echo "Cleaning $(MODULE_NAME) data..."
	@if [ -L "$(LOCAL_BIN)/wbs" ] && [ "$$(readlink "$(LOCAL_BIN)/wbs")" = "$(CURDIR)/bin/wbs" ]; then \
		rm -f "$(LOCAL_BIN)/wbs"; \
	fi
	@echo "   (vault at $(WHALEBYTE_DIR)/.secret left untouched)"
	@echo "✅ $(MODULE_NAME) cleaned."
