XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_DATA_HOME   ?= $(HOME)/.local/share

# Docker settings
MODULE_NAME := docker
DOCKER_VERSION := 24.0.2
DOCKER_INSTALL_BASE := $(HOME)/.local/docker/versions
DOCKER_INSTALL_DIR := $(DOCKER_INSTALL_BASE)/$(DOCKER_VERSION)
DOCKER_BIN := $(DOCKER_INSTALL_DIR)/docker
LOCAL_BIN := $(HOME)/.local/bin

# OS detection
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	DOCKER_OS := linux
	DOCKER_ARCH := x86_64
	DOCKER_URL := https://download.docker.com/linux/static/stable/$(DOCKER_ARCH)/docker-$(DOCKER_VERSION).tgz
endif
ifeq ($(UNAME_S),Darwin)
	DOCKER_OS := darwin
	DOCKER_ARCH := x86_64
	DOCKER_URL := https://download.docker.com/mac/static/stable/$(DOCKER_ARCH)/docker-$(DOCKER_VERSION).tgz
endif

# Phony targets
.PHONY: install check_rancher clean list_versions use_version

# Main install target
install: check_rancher
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@mkdir -p $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@mkdir -p $(XDG_DATA_HOME)/$(MODULE_NAME)
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)

	@echo "Installing Docker $(DOCKER_VERSION) for $(DOCKER_OS)/$(DOCKER_ARCH)..."
	@mkdir -p $(DOCKER_INSTALL_DIR)
	@curl -fSL $(DOCKER_URL) -o /tmp/docker-$(DOCKER_VERSION).tgz || (echo "❌ Download failed!"; exit 1)
	@tar xzf /tmp/docker-$(DOCKER_VERSION).tgz -C $(DOCKER_INSTALL_DIR) --strip-components=1 docker/docker
	@chmod +x $(DOCKER_BIN)
	@mkdir -p $(LOCAL_BIN)
	@ln -sfn $(DOCKER_BIN) $(LOCAL_BIN)/docker
	@echo "Manual Docker installed at $(DOCKER_BIN)"
	@echo "Active Docker symlink: $(LOCAL_BIN)/docker → $(DOCKER_BIN)"

	@if [ -x "$(HOME)/.rd/bin/docker" ]; then \
		echo "ℹ️  Rancher Desktop docker detected at ~/.rd/bin/docker"; \
		echo "Use 'alias rancher-docker=~/.rd/bin/docker' to run it"; \
	fi

	@echo "✅ Docker install complete."

# Only warn if Rancher Docker exists
check_rancher:
	@if [ -x "$(HOME)/.rd/bin/docker" ]; then \
		echo "ℹ️  Rancher Desktop docker detected"; \
	else \
		echo "ℹ️  No Rancher Desktop docker detected"; \
	fi

# List all installed Docker versions
list_versions:
	@echo "Installed Docker versions:"
	@ls -1 $(DOCKER_INSTALL_BASE) 2>/dev/null || echo "No versions installed."

# Switch to a specific installed version
# Usage: make use_version DOCKER_VERSION=24.0.2
use_version:
ifndef DOCKER_VERSION
	$(error DOCKER_VERSION is required. Usage: make use_version DOCKER_VERSION=<version>)
endif
	@if [ -x "$(DOCKER_INSTALL_BASE)/$(DOCKER_VERSION)/docker" ]; then \
		ln -sfn $(DOCKER_INSTALL_BASE)/$(DOCKER_VERSION)/docker $(LOCAL_BIN)/docker; \
		echo "✅ Docker symlink updated to version $(DOCKER_VERSION)"; \
	else \
		echo "❌ Docker version $(DOCKER_VERSION) not installed"; \
	fi

# Clean up installed binaries
clean:
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_CACHE_HOME)/$(MODULE_NAME)
	@rm -rf $(XDG_DATA_HOME)/$(MODULE_NAME)
	@rm -rf $(DOCKER_INSTALL_BASE)
	@rm -f $(LOCAL_BIN)/docker
	@echo "✅ Docker cleaned."
