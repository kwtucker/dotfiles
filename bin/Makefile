MODULE_NAME := bin

.PHONY: install clean

install:
	@echo "Installing $(MODULE_NAME)..."
	@mkdir -p $(HOME)/.local/bin

# NOTE: intentionally a no-op — ~/.local/bin is shared infrastructure
# (mise binary, shims helpers, personal tools). Never `rm -rf` it here.
clean:
	@echo "Skipping $(MODULE_NAME) clean (shared ~/.local/bin left untouched)."
