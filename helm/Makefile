XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_RUNTIME_DIR ?= $(HOME)/.local/run

MODULE_NAME := helm
HELM_VERSION = 3.19.0
HELM_URL = https://get.helm.sh/helm-v$(HELM_VERSION)-darwin-amd64.tar.gz
HELM = helm-$(HELM_VERSION)

.PHONY: install clean

install: $(HOME)/bin/$(HELM)
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
	@rm -rf $(HOME)/.local/bin/$(MODULE_NAME)
	@rm -rf $(HOME)/.local/bin/$(HELM)
	@echo "✅ $(MODULE_NAME) cleaned."

$(HOME)/bin/$(HELM):
	@echo "Installing helm $(HELM_VERSION)..."
	@curl -s $(HELM_URL) | tar xz -C $(HOME)/tmp
	@chmod +x $(HOME)/tmp/darwin-amd64/helm
	@mkdir -p $(HOME)/bin
	@cp $(HOME)/tmp/darwin-amd64/helm $(HOME)/bin/$(HELM)
	@ln -sfn $(HOME)/bin/$(HELM) $(HOME)/bin/helm
	@rm -rf $(HOME)/tmp/darwin-amd64
