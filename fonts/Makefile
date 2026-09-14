include ../env.mk

MODULE_NAME := fonts
FONTS_SRC := $(XDG_CACHE_HOME)/fonts

.PHONY: install clean

install: .ensure.xdg.fonts
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p "$(FONT_DIR)"
	# Inconsolata (Powerline)
	@curl -fsSL "https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf" -o "$(FONT_DIR)/Inconsolata for Powerline.otf"
	# JetBrains Mono (Nerd Font)
	@mkdir -p "$(FONTS_SRC)"
	@curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip" -o "$(FONTS_SRC)/JetBrainsMono.zip"
	@cd "$(FONTS_SRC)" && unzip -oq JetBrainsMono.zip
	@find "$(FONTS_SRC)" -name '*.ttf' -exec mv {} "$(FONT_DIR)/" \;
	@rm -rf "$(FONTS_SRC)"
	# Rebuild font cache on Linux only (macOS manages ~/Library/Fonts automatically)
	@if [ -n "$(FONTCACHE)" ]; then $(FONTCACHE) "$(FONT_DIR)"; fi
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.fonts
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -f "$(FONT_DIR)/Inconsolata for Powerline.otf"
	@rm -f $(FONT_DIR)/JetBrainsMonoNerdFont-*.ttf
	@if [ -n "$(FONTCACHE)" ]; then $(FONTCACHE) "$(FONT_DIR)"; fi
	@echo "✅ $(MODULE_NAME) cleaned."