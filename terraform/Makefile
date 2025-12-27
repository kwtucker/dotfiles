XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_DATA_HOME   ?= $(HOME)/.local/share

MODULE_NAME := terraform

.PHONY: install clean

install:
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)/plugin-cache
	@mkdir -p $(XDG_DATA_HOME)/$(MODULE_NAME)
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@go install github.com/terraform-docs/terraform-docs@v0.19.0

clean:
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_DATA_HOME)/$(MODULE_NAME)
	@rm ~/go/bin/terraform-docs
	@echo "✅ $(MODULE_NAME) cleaned."
