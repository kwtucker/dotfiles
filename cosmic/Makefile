include ../env.mk

MODULE_NAME := cosmic
COSMIC_DIR := $(XDG_CONFIG_HOME)/cosmic
COSMIC_TERM_DIR := $(COSMIC_DIR)/com.system76.CosmicTerm/v1
COLOR_SCHEMES := $(COSMIC_TERM_DIR)/color_schemes_dark
THEME_SOURCES := $(COSMIC_DIR)/dotfiles-themes

.PHONY: install clean

install:
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@$(DOTFILES_LINK) preflight_file "$(CURDIR)/color_schemes_dark" "$(COLOR_SCHEMES)"
	@$(DOTFILES_LINK) preflight_dir "$(CURDIR)/themes" "$(THEME_SOURCES)"
	@mkdir -p "$(COSMIC_TERM_DIR)"
	@$(DOTFILES_LINK) link_file "$(CURDIR)/color_schemes_dark" "$(COLOR_SCHEMES)"
	@$(DOTFILES_LINK) link_dir "$(CURDIR)/themes" "$(THEME_SOURCES)"
	@echo "✅ $(MODULE_NAME) installed."

clean:
	@echo "Cleaning $(MODULE_NAME) data..."
	@$(DOTFILES_LINK) prune_link "$(COLOR_SCHEMES)"
	@$(DOTFILES_LINK) prune_link "$(THEME_SOURCES)"
	@echo "✅ $(MODULE_NAME) cleaned."
