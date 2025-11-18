# XDG base directories
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_RUNTIME_DIR ?= $(HOME)/.local/run

# Detect OS
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	HELM_OS = linux
endif
ifeq ($(UNAME_S),Darwin)
	HELM_OS = darwin
endif

MODULE_NAME := helm

# Helm settings
HELM_VERSION ?= 3.19.0
HELM_ARCH := amd64
HELM_URL = https://get.helm.sh/helm-v$(HELM_VERSION)-$(HELM_OS)-$(HELM_ARCH).tar.gz

# Versioned install structure
HELM_BASE_DIR ?= $(HOME)/.local/helm/versions
HELM_INSTALL_DIR = $(HELM_BASE_DIR)/$(HELM_VERSION)
HELM_BIN = $(HELM_INSTALL_DIR)/helm

LOCAL_BIN = $(HOME)/.local/bin

.PHONY: install install_helm clean list_versions use_version check_rancher

install: check_rancher install_helm
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_DATA_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "Helm installed at $(HELM_BIN)"
	@echo "Active Helm: $(LOCAL_BIN)/helm → $(HELM_BIN)"
	@echo "✅ $(MODULE_NAME) installed."

check_rancher:
	@if [ -x "$(HOME)/.rd/bin/helm" ]; then \
		echo "ℹ️  Rancher Desktop helm detected (~/.rd/bin/helm)"; \
		echo "    This will NOT override your manually installed helm."; \
		echo "    Use: alias rancher-helm=~/.rd/bin/helm"; \
	else \
		echo "ℹ️  No Rancher helm detected."; \
	fi

install_helm:
	@echo "Installing Helm $(HELM_VERSION)..."

	# Create versioned directory
	@mkdir -p $(HELM_INSTALL_DIR)

	# Download and extract the tarball
	@curl -sL $(HELM_URL) | tar xz -C $(HELM_INSTALL_DIR) --strip-components=1 $(HELM_OS)-$(HELM_ARCH)/helm

	@chmod +x $(HELM_BIN)

	# Ensure ~/.local/bin exists
	@mkdir -p $(LOCAL_BIN)

	# Symlink stable helm to this version
	@ln -sfn $(HELM_BIN) $(LOCAL_BIN)/helm

	# Remove old helm-* binaries in ~/.local/bin
	@find $(LOCAL_BIN) -maxdepth 1 -type f -name "helm-*" -delete 2>/dev/null || true

	@echo "Helm $(HELM_VERSION) installed."
	@echo "Active: $(LOCAL_BIN)/helm → $(HELM_BIN)"

# List all installed Helm versions
list_versions:
	@echo "Installed Helm versions:"
	@ls -1 $(HELM_BASE_DIR)

# Switch active Helm version
use_version:
	@if [ -z "$(v)" ]; then echo "Usage: make use_version v=3.18.0"; exit 1; fi
	@if [ ! -f "$(HELM_BASE_DIR)/$(v)/helm" ]; then \
		echo "Helm version $(v) is not installed."; exit 1; \
	fi
	@ln -sfn $(HELM_BASE_DIR)/$(v)/helm $(LOCAL_BIN)/helm
	@echo "Now using Helm $(v)."

clean:
	@echo "Cleaning Helm installation…"
	@rm -rf $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_DATA_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_RUNTIME_DIR)/$(MODULE_NAME)
	@rm -rf $(HELM_BASE_DIR)
	@rm -f $(LOCAL_BIN)/helm
	@echo "✅ Helm cleaned."
