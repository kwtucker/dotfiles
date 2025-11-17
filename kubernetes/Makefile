# Dotfiles directories
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_RUNTIME_DIR ?= $(HOME)/.local/run

# Detect OS
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	KUBECTL_OS = linux
endif
ifeq ($(UNAME_S),Darwin)
	KUBECTL_OS = darwin
endif

MODULE_NAME := kubernetes
KUBECTL_VERSION = 1.34.1
KUBECTL_ARCH := amd64
KUBECTL_URL = https://storage.googleapis.com/kubernetes-release/release/v$(KUBECTL_VERSION)/bin/$(KUBECTL_OS)/$(KUBECTL_ARCH)/kubectl
KUBECTL = kubectl-$(KUBECTL_VERSION)
KUBECTL_INSTALL_DIR ?= $(HOME)/.local/kubectl/bin

.PHONY: install install_kubectl clean

install: check_rancher install_kubectl
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_DATA_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) dotfiles installed."
	@echo "Manual kubectl installed at $(KUBECTL_INSTALL_DIR)/$(KUBECTL)"
	@echo "Active kubectl symlink: ~/.local/bin/kubectl → $(KUBECTL_INSTALL_DIR)/$(KUBECTL)"
	@if [ -x "$(HOME)/.rd/bin/kubectl" ]; then \
		echo "ℹ️  Rancher Desktop kubectl detected at ~/.rd/bin/kubectl"; \
		echo "Use 'alias rancher-kubectl=~/.rd/bin/kubectl' to run it"; \
	fi

# Only warn if Rancher kubectl exists
check_rancher:
	@if [ -x "$(HOME)/.rd/bin/kubectl" ]; then \
		echo "ℹ️  Rancher Desktop kubectl detected"; \
	else \
		echo "ℹ️  No Rancher kubectl detected"; \
	fi

install_kubectl:
	@echo "Installing kubectl $(KUBECTL_VERSION)..."
	@mkdir -p $(KUBECTL_INSTALL_DIR)
	@curl -L $(KUBECTL_URL) -o $(KUBECTL_INSTALL_DIR)/$(KUBECTL)
	@chmod +x $(KUBECTL_INSTALL_DIR)/$(KUBECTL)
	@mkdir -p $(HOME)/.local/bin
	@ln -sfn $(KUBECTL_INSTALL_DIR)/$(KUBECTL) $(HOME)/.local/bin/kubectl

clean:
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_DATA_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@rm -rf $(KUBECTL_INSTALL_DIR)
	@rm -f $(HOME)/.local/bin/$(KUBECTL)
	@rm -f $(HOME)/.local/bin/kubectl
	@echo "✅ $(MODULE_NAME) cleaned."
