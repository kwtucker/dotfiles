include ../env.mk

MODULE_NAME := fonts
FONTS_SRC := $(XDG_CACHE_HOME)/fonts

# Font pins. Bump the version/commit and the SHA-256 together; installs verify
# the digest before anything is written to FONT_DIR.
INCONSOLATA_COMMIT := a029626780dd4af32f15a3e708a5b00528c22f1d
INCONSOLATA_URL := https://raw.githubusercontent.com/powerline/fonts/$(INCONSOLATA_COMMIT)/Inconsolata/Inconsolata%20for%20Powerline.otf
INCONSOLATA_SHA256 := ee07f7241f5a7fed4a7916962bc5d64b8b8b3cfde588cfc69d9692738a2d48ae
JETBRAINS_VERSION := v3.2.0
JETBRAINS_URL := https://github.com/ryanoasis/nerd-fonts/releases/download/$(JETBRAINS_VERSION)/JetBrainsMono.zip
JETBRAINS_SHA256 := 84e7e6648f9d11d4efbc0c737da5061ce9dceb2c0a8cafdfa20cb9adfdcb1a37
JETBRAINS_STAMP := $(FONT_DIR)/.JetBrainsMono.version
# Written when a headless/container install deliberately skips the download, so
# `doctor` and `status` can distinguish "skipped" from "missing".
FONT_SKIP_STAMP := $(DOTFILES_STATE_DIR)/fonts-skipped

.PHONY: install clean

install: .ensure.xdg.fonts
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p "$(FONT_DIR)"; \
	if [ "$${DOTFILES_SKIP_FONTS:-0}" = "1" ]; then \
		if [ "$$(cat "$(JETBRAINS_STAMP)" 2>/dev/null)" = "$(JETBRAINS_VERSION)" ] && \
			[ -f "$(FONT_DIR)/Inconsolata for Powerline.otf" ]; then \
			rm -f "$(FONT_SKIP_STAMP)"; \
			echo "↷ Font download skipped (fonts already installed)."; \
		else \
			mkdir -p "$(dir $(FONT_SKIP_STAMP))"; \
			printf 'skipped: DOTFILES_SKIP_FONTS=1 at %s\n' "$$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$(FONT_SKIP_STAMP)"; \
			echo "↷ Fonts skipped (headless/container; marker: $(FONT_SKIP_STAMP))."; \
		fi; \
	else \
		rm -f "$(FONT_SKIP_STAMP)"; \
		changed=0; \
		if [ ! -f "$(FONT_DIR)/Inconsolata for Powerline.otf" ]; then \
			echo "Fetching Inconsolata for Powerline..."; \
			"$(DOTFILES_FETCH)" "$(INCONSOLATA_URL)" "$(FONT_DIR)/Inconsolata for Powerline.otf" "$(INCONSOLATA_SHA256)" 644 || exit 1; \
			changed=1; \
		fi; \
		if [ "$$(cat "$(JETBRAINS_STAMP)" 2>/dev/null)" != "$(JETBRAINS_VERSION)" ]; then \
			echo "Fetching JetBrains Mono Nerd Font $(JETBRAINS_VERSION)..."; \
			mkdir -p "$(FONTS_SRC)"; \
			"$(DOTFILES_FETCH)" "$(JETBRAINS_URL)" "$(FONTS_SRC)/JetBrainsMono.zip" "$(JETBRAINS_SHA256)" || exit 1; \
			(cd "$(FONTS_SRC)" && unzip -oq JetBrainsMono.zip) || exit 1; \
			find "$(FONTS_SRC)" -name '*.ttf' -exec mv {} "$(FONT_DIR)/" \;; \
			rm -rf "$(FONTS_SRC)"; \
			printf '%s\n' "$(JETBRAINS_VERSION)" > "$(JETBRAINS_STAMP)"; \
			changed=1; \
		fi; \
		if [ "$$changed" = 1 ] && [ -n "$(FONTCACHE)" ] && command -v fc-cache >/dev/null 2>&1; then \
			$(FONTCACHE) "$(FONT_DIR)"; \
		fi; \
	fi
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.fonts
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -f "$(FONT_DIR)/Inconsolata for Powerline.otf"
	@rm -f $(FONT_DIR)/JetBrainsMonoNerdFont*.ttf "$(JETBRAINS_STAMP)" "$(FONT_SKIP_STAMP)"
	@if [ -n "$(FONTCACHE)" ] && command -v fc-cache >/dev/null 2>&1; then $(FONTCACHE) "$(FONT_DIR)"; fi
	@echo "✅ $(MODULE_NAME) cleaned."