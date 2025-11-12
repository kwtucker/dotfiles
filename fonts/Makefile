XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_RUNTIME_DIR ?= $(HOME)/.local/run

MODULE_NAME := fonts 

.PHONY: install clean

install:
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_DATA_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@wget https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf
	@mv Inconsolata\ for\ Powerline.otf $(XDG_DATA_HOME)/fonts/
	@wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip  
	@unzip JetBrainsMono.zip 
	@rm OFL.txt JetBrainsMono.zip README.md
	@sudo mv *.ttf $(XDG_DATA_HOME)/fonts/
	@fc-cache -vf $(XDG_DATA_HOME)/fonts/
	@echo "✅ $(MODULE_NAME) installed."

clean:
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_DATA_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@rm -rf $(XDG_CONFIG_HOME)/fontconfig
	@echo "✅ $(MODULE_NAME) cleaned."
