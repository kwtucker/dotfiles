include ../env.mk

MODULE_NAME := nvim

.PHONY: install clean upgrade

install: .ensure.xdg.nvim
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

upgrade:
	@echo "Upgrading $(MODULE_NAME) plugins..."
	@nvim --headless "+Lazy! sync" +qa || true
	@# MasonUpdate refreshes registries only (headless-safe); `ensure_installed`
	@# packages self-install on the next interactive launch. LazyVim lazy-loads
	@# mason on `:Mason`, so force-load it first — bare `+MasonUpdate` is E492.
	@nvim --headless "+Lazy! load mason.nvim" "+MasonUpdate" +qa || true
	@echo "✅ $(MODULE_NAME) upgraded."

clean: .remove.xdg.nvim
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf ~/.local/state/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) cleaned."
