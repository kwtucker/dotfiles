include ../env.mk

MODULE_NAME := tig
CONFIG_DIR := $(XDG_CONFIG_HOME)/$(MODULE_NAME)

.PHONY: install clean

install:
	@$(DOTFILES_LINK) link_dir "$(CURDIR)" "$(CONFIG_DIR)"
	@echo "✅ $(MODULE_NAME) installed."

clean:
	@if [ -L "$(CONFIG_DIR)" ] && [ "$$(readlink "$(CONFIG_DIR)")" = "$(CURDIR)" ]; then \
		rm "$(CONFIG_DIR)"; \
	fi
	@echo "✅ $(MODULE_NAME) cleaned."
