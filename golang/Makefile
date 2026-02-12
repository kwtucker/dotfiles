include ../env.mk

MODULE_NAME := golang

.PHONY: install clean

install: .ensure.xdg.golang
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@curl -sSfL "https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh" | sh -s -- -b ~/go/bin latest
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.golang
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm ~/go/bin/golangci-lint
	@echo "✅ $(MODULE_NAME) cleaned."
