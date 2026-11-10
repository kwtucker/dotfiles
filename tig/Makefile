include ../env.mk

MODULE_NAME := tig
CONFIG_DIR := $(XDG_CONFIG_HOME)/$(MODULE_NAME)

.PHONY: install clean

install:
	@set -e; \
	if [ -e "$(CONFIG_DIR)" ] || [ -L "$(CONFIG_DIR)" ]; then \
		if [ ! -L "$(CONFIG_DIR)" ] || [ "$$(readlink "$(CONFIG_DIR)")" != "$(CURDIR)" ]; then \
			echo "Conflict: $(CONFIG_DIR) already exists; move it aside before installing." >&2; \
			exit 1; \
		fi; \
	fi; \
	mkdir -p "$(XDG_CONFIG_HOME)"; \
	if [ ! -L "$(CONFIG_DIR)" ]; then ln -s "$(CURDIR)" "$(CONFIG_DIR)"; fi
	@echo "✅ $(MODULE_NAME) installed."

clean:
	@if [ -L "$(CONFIG_DIR)" ] && [ "$$(readlink "$(CONFIG_DIR)")" = "$(CURDIR)" ]; then \
		rm "$(CONFIG_DIR)"; \
	fi
	@echo "✅ $(MODULE_NAME) cleaned."
