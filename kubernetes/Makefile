XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_RUNTIME_DIR ?= $(HOME)/.local/run

MODULE_NAME := kubernetes
KUBECTL_VERSION = 1.34.1
KUBECTL_URL = https://storage.googleapis.com/kubernetes-release/release/v$(KUBECTL_VERSION)/bin/darwin/amd64/kubectl
KUBECTL = kubectl-$(KUBECTL_VERSION)

.PHONY: install clean

install: $(HOME)/bin/$(KUBECTL)
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_DATA_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "✅ $(MODULE_NAME) installed."

clean:
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_DATA_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@rm -rf $(HOME)/.local/bin/kubectl
	@echo "✅ $(MODULE_NAME) cleaned."

$(HOME)/bin/$(KUBECTL):
	@echo "Installing kubectl $(KUBECTL_VERSION)..."
	@curl $(KUBECTL_URL) -o $(HOME)/tmp/$(KUBECTL)
	@chmod +x $(HOME)/tmp/$(KUBECTL)
	@mv $(HOME)/tmp/$(KUBECTL) $(HOME)/.local/bin/$(KUBECTL)
	@ln -sfn $(HOME)/.local/bin/$(KUBECTL) $(HOME)/.local/bin/kubectl

