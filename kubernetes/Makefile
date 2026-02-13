include ../env.mk

# Detect OS
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	KUBECTL_OS = linux
endif
ifeq ($(UNAME_S),Darwin)
	KUBECTL_OS = darwin
endif

MODULE_NAME := kubernetes

# kubectl settings
KUBECTL_VERSION ?= 1.31.0
KUBECTL_ARCH := amd64
KUBECTL_URL = https://storage.googleapis.com/kubernetes-release/release/v$(KUBECTL_VERSION)/bin/$(KUBECTL_OS)/$(KUBECTL_ARCH)/kubectl

# Versioned install structure
KUBECTL_BASE_DIR ?= $(HOME)/.local/kubectl/versions
KUBECTL_INSTALL_DIR = $(KUBECTL_BASE_DIR)/$(KUBECTL_VERSION)
KUBECTL_BIN = $(KUBECTL_INSTALL_DIR)/kubectl

LOCAL_BIN = $(HOME)/.local/bin

.PHONY: install install_kubectl clean list_versions use_version check_rancher

install: .ensure.xdg.kubernetes check_rancher install_kubectl
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@echo "kubectl installed at $(KUBECTL_BIN)"
	@echo "Active kubectl: $(LOCAL_BIN)/kubectl → $(KUBECTL_BIN)"
	@echo "✅ $(MODULE_NAME) installed."

check_rancher:
	@if [ -x "$(HOME)/.rd/bin/kubectl" ]; then \
		echo "ℹ️  Rancher Desktop kubectl detected (~/.rd/bin/kubectl)"; \
		echo "    This will NOT override your manually installed kubectl."; \
		echo "    Use: alias rancher-kubectl=~/.rd/bin/kubectl"; \
	else \
		echo "ℹ️  No Rancher kubectl detected."; \
	fi

install_kubectl:
	@echo "Installing kubectl $(KUBECTL_VERSION)..."

	# Create versioned directory
	@mkdir -p $(KUBECTL_INSTALL_DIR)

	# Download kubectl into the version directory
	@curl -fL $(KUBECTL_URL) -o $(KUBECTL_BIN)
	@chmod +x $(KUBECTL_BIN)

	@$(KUBECTL_BIN) version --client >/dev/null

	# Ensure ~/.local/bin exists
	@mkdir -p $(LOCAL_BIN)

	# Symlink stable kubectl to this specific version
	@ln -sfn $(KUBECTL_BIN) $(LOCAL_BIN)/kubectl

	# Remove any old "kubectl-*" files from ~/.local/bin
	@find $(LOCAL_BIN) -maxdepth 1 -type f -name "kubectl-*" -delete 2>/dev/null || true

	@echo "kubectl $(KUBECTL_VERSION) installed."
	@echo "Active: $(LOCAL_BIN)/kubectl → $(KUBECTL_BIN)"

# List all installed kubectl versions
list_versions:
	@echo "Installed kubectl versions:"
	@ls -1 $(KUBECTL_BASE_DIR)

# Switch active kubectl version
use_version:
	@if [ -z "$(v)" ]; then echo "Usage: make use_version v=1.33.0"; exit 1; fi
	@if [ ! -f "$(KUBECTL_BASE_DIR)/$(v)/kubectl" ]; then \
		echo "kubectl version $(v) is not installed."; exit 1; \
	fi
	@ln -sfn $(KUBECTL_BASE_DIR)/$(v)/kubectl $(LOCAL_BIN)/kubectl
	@echo "Now using kubectl $(v)."

clean: .remove.xdg.kubernetes
	@echo "Cleaning kubectl installation…"
	@rm -rf $(KUBECTL_BASE_DIR)
	@rm -f $(LOCAL_BIN)/kubectl
	@echo "✅ kubectl cleaned."
