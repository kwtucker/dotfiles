include ../env.mk

MODULE_NAME := terraform

.PHONY: install clean

install: .ensure.xdg.terraform
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)/plugin-cache
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@go install github.com/terraform-docs/terraform-docs@v0.19.0

clean: .remove.xdg.terraform
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm ~/go/bin/terraform-docs
	@echo "✅ $(MODULE_NAME) cleaned."
