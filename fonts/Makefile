include ../env.mk

MODULE_NAME := fonts

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
	FONT_DIR := $(HOME)/Library/Fonts
else
	FONT_DIR := $(XDG_DATA_HOME)/fonts
endif

.PHONY: install clean

install: .ensure.xdg.fonts
	@echo "Installing $(MODULE_NAME)..."
	@mkdir -p "$(FONT_DIR)"

	# Inconsolata for Powerline
	@curl -fsSL \
		-o "Inconsolata for Powerline.otf" \
		"https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf"
	@mv "Inconsolata for Powerline.otf" "$(FONT_DIR)/"

	# JetBrains Mono Nerd Font
	@curl -fsSL \
		-o JetBrainsMono.zip \
		"https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip"
	@unzip -q -o JetBrainsMono.zip
	@mv *.ttf "$(FONT_DIR)/"
	@rm -f JetBrainsMono.zip OFL.txt README.md

	# Refresh font cache on Linux
	@if command -v fc-cache >/dev/null 2>&1; then \
		fc-cache -fv "$(FONT_DIR)"; \
	fi

	@echo "✅ Fonts installed to $(FONT_DIR)"

clean: .remove.xdg.fonts
	@echo "Cleaning $(MODULE_NAME)..."
	@rm -f "$(FONT_DIR)/Inconsolata for Powerline.otf"
	@rm -f "$(FONT_DIR)"/JetBrainsMono*.ttf

	@if command -v fc-cache >/dev/null 2>&1; then \
		fc-cache -fv "$(FONT_DIR)"; \
	fi

	@echo "✅ $(MODULE_NAME) cleaned."
