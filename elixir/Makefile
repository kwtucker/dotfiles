include ../env.mk

MODULE_NAME := elixir

# ===== Versions (change these anytime) =====
ELIXIR_VERSION ?= 1.19.5
OTP_VERSION    ?= 28.1

# Combined label used by installer
ELIXIR_LABEL = elixir@$(ELIXIR_VERSION)
OTP_LABEL    = otp@$(OTP_VERSION)

# Where the official installer puts builds
ELIXIR_INSTALL_ROOT := $(HOME)/.elixir-install
ELIXIR_INSTALLS_DIR := $(ELIXIR_INSTALL_ROOT)/installs

# Versioned layout we control
ELIXIR_BASE_DIR ?= $(HOME)/.local/elixir/versions
ELIXIR_VERSION_DIR := $(ELIXIR_BASE_DIR)/$(ELIXIR_VERSION)-otp-$(OTP_VERSION)

# Binaries
ELIXIR_BIN_DIR := $(ELIXIR_VERSION_DIR)/elixir/bin
OTP_BIN_DIR    := $(ELIXIR_VERSION_DIR)/otp/bin

LOCAL_BIN = $(HOME)/.local/bin

INSTALL_SCRIPT := $(XDG_CACHE_HOME)/$(MODULE_NAME)/install.sh

.PHONY: install install_elixir link_bins list_versions use_version clean

install: .ensure.xdg.elixir install_elixir link_bins
	@echo "✅ Elixir $(ELIXIR_VERSION) with OTP $(OTP_VERSION) installed."
	@echo "Elixir bin: $(LOCAL_BIN)/elixir"
	@echo "IEx bin:    $(LOCAL_BIN)/iex"

# Download and run official installer
install_elixir:
	@echo "Installing Elixir $(ELIXIR_VERSION) + OTP $(OTP_VERSION)..."

	@mkdir -p $(ELIXIR_BASE_DIR)

	# Fetch installer script if missing
	@if [ ! -f "$(INSTALL_SCRIPT)" ]; then \
		curl -fsSL https://elixir-lang.org/install.sh -o $(INSTALL_SCRIPT); \
		chmod +x $(INSTALL_SCRIPT); \
	fi

	# Run installer (installs into ~/.elixir-install)
	@bash $(INSTALL_SCRIPT) $(ELIXIR_LABEL) $(OTP_LABEL)

	# Create our managed version directory
	@mkdir -p $(ELIXIR_VERSION_DIR)

	# Copy installed builds into versioned directory
	@cp -R $(ELIXIR_INSTALLS_DIR)/elixir/$(ELIXIR_VERSION)-otp-$(OTP_VERSION)/* $(ELIXIR_VERSION_DIR)/elixir
	@cp -R $(ELIXIR_INSTALLS_DIR)/otp/$(OTP_VERSION)/* $(ELIXIR_VERSION_DIR)/otp

# Symlink stable binaries into ~/.local/bin
link_bins:
	@mkdir -p $(LOCAL_BIN)

	@ln -sfn $(ELIXIR_BIN_DIR)/elixir $(LOCAL_BIN)/elixir
	@ln -sfn $(ELIXIR_BIN_DIR)/iex $(LOCAL_BIN)/iex
	@ln -sfn $(ELIXIR_BIN_DIR)/mix $(LOCAL_BIN)/mix

	@echo "🔗 Linked elixir, iex, and mix into $(LOCAL_BIN)"

# List installed versions
list_versions:
	@echo "Installed Elixir versions:"
	@ls -1 $(ELIXIR_BASE_DIR)

# Switch active version
use_version:
	@if [ -z "$(v)" ]; then echo "Usage: make use_version v=1.19.4-otp-28.0"; exit 1; fi
	@if [ ! -d "$(ELIXIR_BASE_DIR)/$(v)" ]; then \
		echo "Version $(v) not installed."; exit 1; \
	fi
	@ln -sfn $(ELIXIR_BASE_DIR)/$(v)/elixir/bin/elixir $(LOCAL_BIN)/elixir
	@ln -sfn $(ELIXIR_BASE_DIR)/$(v)/elixir/bin/iex $(LOCAL_BIN)/iex
	@ln -sfn $(ELIXIR_BASE_DIR)/$(v)/elixir/bin/mix $(LOCAL_BIN)/mix
	@echo "Now using Elixir $(v)"

clean: .remove.xdg.elixir
	@echo "Cleaning Elixir installs..."
	@rm -rf $(ELIXIR_BASE_DIR)
	@rm -f $(LOCAL_BIN)/elixir $(LOCAL_BIN)/iex $(LOCAL_BIN)/mix
	@echo "✅ Cleaned."
