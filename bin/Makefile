include ../env.mk

MODULE_NAME := bin
BIN_DIR := $(HOME)/.local/bin
SCRIPT_DIR := $(CURDIR)

.PHONY: install clean

# Link every executable script kept in this directory (except this Makefile) into
# $(BIN_DIR). The module is intentionally generic: it has no knowledge of any
# particular tool. Preflight each target so an unrelated local script is never
# replaced.
install:
	@echo "Installing $(MODULE_NAME)..."
	@mkdir -p "$(BIN_DIR)"
	@found=0; \
	for script in "$(SCRIPT_DIR)"/*; do \
		[ -e "$$script" ] || continue; \
		name="$$(basename "$$script")"; \
		[ "$$name" = "Makefile" ] && continue; \
		[ -f "$$script" ] || continue; \
		if [ ! -x "$$script" ]; then \
			echo "Skipping non-executable: $$script" >&2; \
			continue; \
		fi; \
		found=1; \
		target="$(BIN_DIR)/$$name"; \
		if [ -e "$$target" ] || [ -L "$$target" ]; then \
			if [ ! -L "$$target" ] || [ "$$(readlink "$$target")" != "$$script" ]; then \
				echo "Conflict: $$target already exists; move it aside before installing." >&2; \
				exit 1; \
			fi; \
		else \
			ln -s "$$script" "$$target"; \
			echo "Linked $$target."; \
		fi; \
	done; \
	if [ "$$found" -eq 0 ]; then \
		echo "No executable scripts in $(SCRIPT_DIR); nothing to link."; \
	fi

# NOTE: ~/.local/bin is shared infrastructure (mise binary, shims helpers, personal
# tools). Remove only links this module owns; never delete the directory or anything
# else in it.
clean:
	@echo "Cleaning $(MODULE_NAME)..."
	@for script in "$(SCRIPT_DIR)"/*; do \
		[ -e "$$script" ] || continue; \
		name="$$(basename "$$script")"; \
		[ "$$name" = "Makefile" ] && continue; \
		[ -f "$$script" ] || continue; \
		[ -x "$$script" ] || continue; \
		target="$(BIN_DIR)/$$name"; \
		if [ -L "$$target" ] && [ "$$(readlink "$$target")" = "$$script" ]; then \
			rm -f "$$target"; \
			echo "Removed $$target."; \
		fi; \
	done
