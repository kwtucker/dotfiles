SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

# Parallel module installs. NUM_CPUS is portable (Linux + macOS). Grouped output
# (--output-sync) keeps the log readable and is only used on GNU Make >= 4;
# macOS ships make 3.81, which lacks it, so we fall back to plain -j. An
# explicit -j on the command line is respected.
NUM_CPUS := $(shell getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)
OUTPUT_SYNC := $(shell $(MAKE) --version 2>/dev/null | head -1 | grep -qE 'GNU Make ([4-9]|1[0-9])\.' && echo --output-sync=recurse)
JOBS := $(if $(filter -j% --jobs%,$(MAKEFLAGS)),,-j$(NUM_CPUS))
MAKEFLAGS += $(JOBS) $(OUTPUT_SYNC) --no-print-directory

# If the file doesn't exist it will not error.
-include modules.local.mk

# Shared XDG vars (also makes ZSH_COMPLETIONS_DIR available below).
include env.mk

# Tracked install-time module sets. Selection precedence:
#   PROFILE=<name> > DOTFILES_PROFILE > profile.local (ignored) > full
include profiles.mk

PROFILE ?= $(DOTFILES_PROFILE)
ifeq ($(strip $(PROFILE)),)
PROFILE := $(strip $(shell cat profile.local 2>/dev/null))
endif
ifeq ($(strip $(PROFILE)),)
PROFILE_MODULES := $(DEFAULT_MODULES)
else
ifeq ($(filter $(PROFILE),$(PROFILE_NAMES)),)
$(error Unknown profile '$(PROFILE)'; expected one of: $(PROFILE_NAMES). Fix profile.local or pass PROFILE=<name>)
else
PROFILE_MODULES := $(PROFILE_MODULES_$(PROFILE))
endif
endif

# Effective profile for metadata and the applied-state stamp. No explicit
# selection keeps the historic full install.
ACTIVE_PROFILE := $(if $(strip $(PROFILE)),$(strip $(PROFILE)),full)

MISSING_PROFILE_MODULES := $(foreach m,$(PROFILE_MODULES),$(if $(wildcard $(DOTFILES_ROOT_DIR)/$(m)/Makefile),,$(m)))
ifneq ($(strip $(MISSING_PROFILE_MODULES)),)
$(error Profile '$(if $(strip $(PROFILE)),$(PROFILE),full)' references unknown modules: $(MISSING_PROFILE_MODULES))
endif

# LOCAL_MODULES stays additive; drop duplicates while preserving profile order.
MODULES := $(strip $(PROFILE_MODULES) $(filter-out $(PROFILE_MODULES),$(LOCAL_MODULES)))

# Optional modules — installed on demand (`make <module>`), not part of `make all`.
OPTIONAL_MODULES = copilot

TARGETS := $(MODULES) $(filter-out $(MODULES),$(OPTIONAL_MODULES))

# Tracked mise tool ownership per module and profile. Must be included after
# MODULES, OPTIONAL_MODULES, and ACTIVE_PROFILE are resolved.
include tools.mk

# Shell sources checked by `make lint`. `install` has no .sh suffix.
SHELL_SCRIPTS := install scripts/state scripts/fetch scripts/prune-links scripts/bootstrap-mise.sh $(wildcard scripts/lib/*.sh)
SHELLCHECK ?= $(shell mise which shellcheck 2>/dev/null || command -v shellcheck 2>/dev/null)
SHFMT ?= $(shell mise which shfmt 2>/dev/null || command -v shfmt 2>/dev/null)
SHFMT_FLAGS := -i 2 -ci

# Hidden, machine-readable metadata for scripts/state (read-only). Keeping the
# module inventory here makes Make the single source of truth; no shell script
# parses this Makefile.
.PHONY: .list.modules .list.paths .list.profiles .list.tools

.list.modules:
	@printf 'profile\t%s\n' "$(ACTIVE_PROFILE)"
	@for m in $(MODULES); do printf 'enabled\t%s\n' "$$m"; done
	@for m in $(filter-out $(MODULES),$(OPTIONAL_MODULES)); do printf 'optional\t%s\n' "$$m"; done

.list.tools:
	@printf 'profile\t%s\n' "$(ACTIVE_PROFILE)"
	@for t in $(ACTIVE_TOOLS); do printf 'active\t%s\n' "$$t"; done
	@for t in $(MANAGED_TOOLS); do printf 'managed\t%s\n' "$$t"; done
	@for t in $(UNMAPPED_TOOLS); do printf 'unmapped\t%s\n' "$$t"; done

.list.profiles:
	@$(foreach p,$(PROFILE_NAMES),printf '%s\t%s\t%s\n' '$(p)' '$(PROFILE_DESCRIPTION_$(p))' '$(if $(filter $(p),$(ACTIVE_PROFILE)),1,0)';)

.list.paths:
	@printf 'config\t%s\n' "$(XDG_CONFIG_HOME)"
	@printf 'cache\t%s\n' "$(XDG_CACHE_HOME)"
	@printf 'data\t%s\n' "$(XDG_DATA_HOME)"
	@printf 'state\t%s\n' "$(XDG_STATE_HOME)"
	@printf 'completions\t%s\n' "$(ZSH_COMPLETIONS_DIR)"
	@printf 'font\t%s\n' "$(FONT_DIR)"

profile.list: ## List install-time module profiles
	@printf '%-14s %-8s %s\n' "PROFILE" "ACTIVE" "DESCRIPTION"
	@$(MAKE) -s --no-print-directory .list.profiles | awk -F '\t' '{ printf "%-14s %-8s %s\n", $$1, ($$3 == "1" ? "active" : ""), $$2 }'

profile.show: ## Show the active profile, its modules, and tool count
	@printf 'profile: %s\n' "$(ACTIVE_PROFILE)$(if $(strip $(PROFILE)),, (default))"
	@printf 'modules: %s\n' "$(MODULES)"
	@printf 'tools: %s\n' "$(words $(ACTIVE_TOOLS))"

profile.set: ## Save this machine's profile (PROFILE=<name>)
	@[ -n "$(strip $(PROFILE))" ] || { echo "error: PROFILE=<name> required; see 'make profile.list'" >&2; exit 2; }
	@printf '%s\n' "$(PROFILE)" > profile.local
	@echo "Saved profile '$(PROFILE)' to profile.local."
	@echo "Run ./install to apply it; modules no longer selected are cleaned."

profile.clear: ## Remove the saved profile (fall back to full)
	@rm -f profile.local
	@echo "Removed profile.local; the full module set is the default."

tools.list: ## Show the mise tools the active profile installs
	@printf 'profile: %s\n' "$(ACTIVE_PROFILE)"
	@printf 'modules: %s\n' "$(MODULES)"
	@printf 'tools: %s\n' "$(words $(ACTIVE_TOOLS))"
	@for t in $(ACTIVE_TOOLS); do printf '  %s\n' "$$t"; done

tools.install: ## Install the mise tools required by the active profile
	@if ! command -v mise >/dev/null 2>&1; then \
		echo "error: mise not found — run ./install to bootstrap it" >&2; \
		exit 1; \
	fi
	@if [ -z "$(strip $(ACTIVE_TOOLS))" ]; then \
		echo "error: no active tools resolved for profile $(ACTIVE_PROFILE)" >&2; \
		exit 1; \
	fi
	@echo "Installing $(words $(ACTIVE_TOOLS)) active tool(s) for profile $(ACTIVE_PROFILE)..."
	@MISE_YES=1 mise install --yes $(ACTIVE_TOOLS)
	@mise reshim

tools.check: ## Validate tool ownership against mise.toml (offline)
	@fail=0; \
	if [ -n "$(strip $(MISSING_TOOL_DECLS))" ]; then \
		echo "error: missing TOOLS_<module> declaration in tools.mk for: $(MISSING_TOOL_DECLS)" >&2; \
		fail=1; \
	fi; \
	if [ -n "$(strip $(UNKNOWN_MAPPED_TOOLS))" ]; then \
		echo "error: tools.mk references names that are not in mise.toml: $(UNKNOWN_MAPPED_TOOLS)" >&2; \
		fail=1; \
	fi; \
	if [ -n "$(strip $(UNMAPPED_TOOLS))" ]; then \
		echo "warn: unclassified mise tools (treated as shared): $(UNMAPPED_TOOLS)" >&2; \
	fi; \
	echo "checked $(words $(MISE_TOOL_KEYS)) mise tool(s): $(words $(MANAGED_TOOLS)) managed, $(words $(BASE_TOOLS) $(SHARED_TOOLS)) base/shared, $(words $(UNMAPPED_TOOLS)) unclassified"; \
	exit $$fail

CLEAN := $(addsuffix .clean,$(TARGETS))

UPGRADE := $(addsuffix .upgrade,$(TARGETS))

# Modules with a `completions` target — completions are refreshed after tool upgrades.
COMPLETION_MODULES := kubernetes helm fzf ripgrep docker golang rust terraform zsh git

$(TARGETS):
	@echo "▶ $@"
	@$(MAKE) -C $@ install
	@if grep -qE '^\.PHONY:.*completions|^completions:' $@/Makefile 2>/dev/null; then \
		mkdir -p $(ZSH_COMPLETIONS_DIR); \
		$(MAKE) -C $@ completions; \
	else \
		echo "==> Skipping $@ (no completions target)"; \
	fi

# Install shared skills once, before either client (including parallel installs).
opencode copilot: agents

$(CLEAN):
	@echo "▶ $(basename $@) (clean)"
	@$(MAKE) -C $(basename $@) clean

# Per-module plugin upgrade: delegates to `<module>/Makefile#upgrade` when it
# exists, otherwise skips (same UX as the completions hook above). Honors
# LOCAL_MODULES / OPTIONAL_MODULES via $(TARGETS).
# NOTE: explicit list (not a %.upgrade pattern rule) — GNU make skips
# implicit rule search for .PHONY targets, so a pattern rule would never fire.
$(UPGRADE):
	@if grep -qE '^\.PHONY:.*upgrade|^upgrade:' $(basename $@)/Makefile 2>/dev/null; then \
		echo "▶ $(basename $@) (upgrade)"; \
		$(MAKE) -C $(basename $@) upgrade; \
	else \
		echo "==> Skipping $(basename $@) (no upgrade target)"; \
	fi

all: $(MODULES) ## Install the selected profile's modules (parallel)
	@if command -v mise >/dev/null 2>&1; then \
		missing="$$(mise ls --missing --no-header 2>/dev/null | awk -v active=" $(ACTIVE_TOOLS) " 'index(active, " " $$1 " ") { print $$1 }' | tr '\n' ' ')"; \
		if [ -n "$$missing" ]; then \
			echo "  ↷ active tools missing: $$missing"; \
			echo "    run 'make tools.install' or './install'"; \
		fi; \
	fi

# Single entrypoint for fresh installs and updates — delegates to ./install so
# context detection (fresh vs existing machine) lives in one place.
install: ## Install or update this machine in any context (runs ./install)
	@./install

update: install ## Update an existing machine (alias for `install`)

clean.all: $(CLEAN) ## Clean all selected modules
	@rmdir "$(ZSH_COMPLETIONS_DIR)" "$(XDG_DATA_HOME)/zsh" 2>/dev/null || true

outdated: ## Show outdated tools (no changes)
	@mise outdated || true
	@echo ""
	@echo "Tip: 'mise outdated --bump' shows versions outside pinned ranges (bumps stay manual)."

doctor: ## Diagnose install state (read-only; offline unless ARGS=--online)
	@scripts/state doctor $(ARGS)

status: ## Show repository, applied, and filesystem state (read-only)
	@scripts/state status $(ARGS)

prune.links: ## List stale links into this checkout (dry run)
	@scripts/prune-links $(ARGS)

prune.links.apply: ## Remove stale links into this checkout
	@scripts/prune-links --force

lint: ## Lint shell scripts (bash -n, shellcheck, shfmt)
	@fail=0; \
	for f in $(SHELL_SCRIPTS); do \
		bash -n "$$f" || fail=1; \
	done; \
	if [ -n "$(SHELLCHECK)" ]; then \
		$(SHELLCHECK) -x $(SHELL_SCRIPTS) || fail=1; \
	else \
		echo "error: shellcheck not found — run 'make tools.install'" >&2; fail=1; \
	fi; \
	if [ -n "$(SHFMT)" ]; then \
		$(SHFMT) -d $(SHFMT_FLAGS) $(SHELL_SCRIPTS) || fail=1; \
	else \
		echo "error: shfmt not found — run 'make tools.install'" >&2; fail=1; \
	fi; \
	exit $$fail

fmt: ## Format shell scripts with shfmt
	@if [ -n "$(SHFMT)" ]; then \
		$(SHFMT) -w $(SHFMT_FLAGS) $(SHELL_SCRIPTS); \
	else \
		echo "error: shfmt not found — run 'make tools.install'" >&2; exit 1; \
	fi

upgrade.tools: ## Upgrade mise tools within pinned ranges + refresh lockfile/completions
	@MISE_YES=1 mise upgrade --yes
	@mise reshim
	@for m in $(COMPLETION_MODULES); do \
		if grep -qE '^\.PHONY:.*completions|^completions:' $$m/Makefile 2>/dev/null; then \
			mkdir -p $(ZSH_COMPLETIONS_DIR); \
			$(MAKE) -C $$m completions; \
		fi; \
	done
	@$(MAKE) prune.tools

prune.tools: ## Remove superseded mise tool versions (keeps referenced ones)
	@MISE_YES=1 mise prune --yes
	@mise reshim

upgrade.plugins: $(UPGRADE) ## Upgrade editor/shell plugins (nvim, tmux, zsh, opencode)

upgrade.all: upgrade.tools upgrade.plugins ## Upgrade tools + plugins

.PHONY: $(TARGETS) $(CLEAN) $(UPGRADE) install update all clean.all outdated doctor status prune.links prune.links.apply lint fmt upgrade.tools prune.tools upgrade.plugins upgrade.all profile.list profile.show profile.set profile.clear tools.list tools.install tools.check

help: ## Show this help message
	@echo "Available targets:"; \
	echo; \
	awk 'BEGIN {FS="##"; printf "\x1b[1;34m%-20s\x1b[0m %s\n","Target","Description"; print "-------------------- ----------------------------"} /^[a-zA-Z0-9_.-]+:/ && $$1 !~ /^\./ {split($$1,parts,":"); target=parts[1]; gsub(/^[ \t]+|[ \t]+$$/,"",target); desc=($$2?$$2:"No description"); gsub(/^[ \t]+/,"",desc); printf "\x1b[36m%-20s\x1b[0m %s\n",target,desc}' $(MAKEFILE_LIST); \
	echo; \
	echo "Usage:"; \
	echo "  make <target>       # Run a specific target"; \
	echo "  make install        # Install or update this machine (runs ./install)"; \
	echo "  make update         # Update an existing machine (alias for install)"; \
	echo "  make all            # Relink the selected profile's modules (parallel)"; \
	echo "  make profile.list   # List install-time module profiles"; \
	echo "  make profile.show   # Show the active profile, modules, and tool count"; \
	echo "  make profile.set    # Save a profile for this machine (PROFILE=<name>)"; \
	echo "  make profile.clear  # Remove profile.local (fall back to full)"; \
	echo "  make tools.list     # Show mise tools the active profile installs"; \
	echo "  make tools.install  # Install mise tools required by the active profile"; \
	echo "  make tools.check    # Validate tool ownership against mise.toml"; \
	echo "  make clean.all      # Clean all selected modules"; \
	echo "  make <module>.clean # Clean a specific module, e.g. 'make zsh.clean'"; \
	echo "  make outdated       # Preview outdated tools (no changes)"; \
	echo "  make doctor         # Diagnose install state (read-only)"; \
	echo "  make status         # Show repo, applied, and filesystem state"; \
	echo "  make prune.links    # List stale links (dry run)"; \
	echo "  make prune.links.apply # Remove stale links into this checkout"; \
	echo "  make lint           # Check shell scripts (bash -n, shellcheck, shfmt)"; \
	echo "  make fmt            # Format shell scripts with shfmt"; \
	echo "  make upgrade.tools  # Upgrade mise tools within pinned ranges"; \
	echo "  make prune.tools    # Remove superseded mise tool versions"; \
	echo "  make upgrade.plugins # Upgrade editor/shell plugins"; \
	echo "  make upgrade.all    # Upgrade tools + plugins"
