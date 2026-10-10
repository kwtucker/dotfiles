include ../env.mk

MODULE_NAME := fonts
FONTS_SRC := $(XDG_CACHE_HOME)/fonts

# Nerd Font release pin. A matching stamp file makes install idempotent so the
# (~117 MB) zip is only fetched when the pin changes.
JETBRAINS_VERSION := v3.2.0
JETBRAINS_STAMP := $(FONT_DIR)/.JetBrainsMono.version

.PHONY: install clean

install: .ensure.xdg.fonts
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p "$(FONT_DIR)"; \
	changed=0; \
	if [ ! -f "$(FONT_DIR)/Inconsolata for Powerline.otf" ]; then \
		curl -fsSL "https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf" -o "$(FONT_DIR)/Inconsolata for Powerline.otf"; \
		changed=1; \
	fi; \
	if [ "$$(cat "$(JETBRAINS_STAMP)" 2>/dev/null)" != "$(JETBRAINS_VERSION)" ]; then \
		echo "Fetching JetBrains Mono Nerd Font $(JETBRAINS_VERSION)..."; \
		mkdir -p "$(FONTS_SRC)"; \
		curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/$(JETBRAINS_VERSION)/JetBrainsMono.zip" -o "$(FONTS_SRC)/JetBrainsMono.zip"; \
		cd "$(FONTS_SRC)" && unzip -oq JetBrainsMono.zip; \
		find "$(FONTS_SRC)" -name '*.ttf' -exec mv {} "$(FONT_DIR)/" \;; \
		rm -rf "$(FONTS_SRC)"; \
		printf '%s\n' "$(JETBRAINS_VERSION)" > "$(JETBRAINS_STAMP)"; \
		changed=1; \
	fi; \
	if [ "$$changed" = 1 ] && [ -n "$(FONTCACHE)" ] && command -v fc-cache >/dev/null 2>&1; then \
		$(FONTCACHE) "$(FONT_DIR)"; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.fonts
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -f "$(FONT_DIR)/Inconsolata for Powerline.otf"
	@rm -f $(FONT_DIR)/JetBrainsMonoNerdFont*.ttf "$(JETBRAINS_STAMP)"
	@if [ -n "$(FONTCACHE)" ] && command -v fc-cache >/dev/null 2>&1; then $(FONTCACHE) "$(FONT_DIR)"; fi
	@echo "✅ $(MODULE_NAME) cleaned."