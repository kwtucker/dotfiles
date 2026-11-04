include ../env.mk

MODULE_NAME := nvim
NVIM ?= nvim
CONFIG_LINK := $(XDG_CONFIG_HOME)/$(MODULE_NAME)

.PHONY: install clean restore upgrade prepare mason-install

install:
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@if [ -e "$(CONFIG_LINK)" ] || [ -L "$(CONFIG_LINK)" ]; then \
		if [ ! -L "$(CONFIG_LINK)" ] || [ "$$(readlink "$(CONFIG_LINK)")" != "$(CURDIR)" ]; then \
			echo "Conflict: $(CONFIG_LINK) already exists; review and move it aside before installing." >&2; \
			exit 1; \
		fi; \
	fi
	@mkdir -p "$(XDG_CONFIG_HOME)"
	@if [ ! -L "$(CONFIG_LINK)" ]; then ln -s "$(CURDIR)" "$(CONFIG_LINK)"; fi
	@echo "✅ $(MODULE_NAME) installed."

# Restore honors lazy-lock.json; only upgrade deliberately advances revisions.
# The helper exits on success; cquit also covers failures before it can load.
restore upgrade prepare mason-install:
	@NVIM_MAINTENANCE=1 "$(NVIM)" --headless "+lua require('config.maintenance').run('$@')" "+cquit 1"

# No data/cache/state removal: plugin checkouts, undo history, and sessions survive.
clean:
	@if [ -L "$(CONFIG_LINK)" ] && [ "$$(readlink "$(CONFIG_LINK)")" = "$(CURDIR)" ]; then \
		rm "$(CONFIG_LINK)"; \
	fi
	@echo "Neovim config unlinked; data, cache, and state preserved."
