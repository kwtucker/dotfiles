SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

# Parallel module installs. NUM_CPUS is portable (Linux + macOS). Grouped output
# (--output-sync) keeps the log readable and is only used on GNU Make >= 4;
# macOS ships make 3.81, which lacks it, so we fall back to plain -j. An
# explicit -j on the command line is respected.
NUM_CPUS := $(shell getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)
OUTPUT_SYNC := $(shell $(MAKE) --version 2>/dev/null | head -1 | grep -qE 'GNU Make ([4-9]|1[0-9])\.' && echo --output-sync=recurse)
JOBS := $(if $(filter -j% --jobs%,$(MAKEFLAGS)),,-j$(NUM_CPUS))
MAKEFLAGS += $(JOBS) $(OUTPUT_SYNC)

# If the file doesn't exist it will not error.
-include modules.local.mk

# Shared XDG vars (also makes ZSH_COMPLETIONS_DIR available below).
include env.mk

MODULES = \
	  bin zsh alacritty fzf tmux git tig golang kubernetes helm terraform docker \
	  bat nvim psql ripgrep fonts rust agents opencode $(LOCAL_MODULES)

# Optional modules — installed on demand (`make <module>`), not part of `make all`.
OPTIONAL_MODULES = copilot

TARGETS := $(MODULES) $(filter-out $(MODULES),$(OPTIONAL_MODULES))

# Shell sources checked by `make lint`. `install` has no .sh suffix.
SHELL_SCRIPTS := install scripts/state scripts/fetch scripts/bootstrap-mise.sh $(wildcard scripts/lib/*.sh)
SHELLCHECK ?= $(shell mise which shellcheck 2>/dev/null || command -v shellcheck 2>/dev/null)
SHFMT ?= $(shell mise which shfmt 2>/dev/null || command -v shfmt 2>/dev/null)
SHFMT_FLAGS := -i 2 -ci

# Hidden, machine-readable metadata for scripts/state (read-only). Keeping the
# module inventory here makes Make the single source of truth; no shell script
# parses this Makefile.
.PHONY: .list.modules .list.paths

.list.modules:
	@for m in $(MODULES); do printf 'enabled\t%s\n' "$$m"; done
	@for m in $(filter-out $(MODULES),$(OPTIONAL_MODULES)); do printf 'optional\t%s\n' "$$m"; done

.list.paths:
	@printf 'config\t%s\n' "$(XDG_CONFIG_HOME)"
	@printf 'cache\t%s\n' "$(XDG_CACHE_HOME)"
	@printf 'data\t%s\n' "$(XDG_DATA_HOME)"
	@printf 'state\t%s\n' "$(XDG_STATE_HOME)"
	@printf 'completions\t%s\n' "$(ZSH_COMPLETIONS_DIR)"
	@printf 'font\t%s\n' "$(FONT_DIR)"

CLEAN := $(addsuffix .clean,$(TARGETS))

UPGRADE := $(addsuffix .upgrade,$(TARGETS))

# Modules with a `completions` target — completions are refreshed after tool upgrades.
COMPLETION_MODULES := kubernetes helm fzf ripgrep docker golang rust terraform zsh git

$(TARGETS):
	$(MAKE) -C $@ install
	@if grep -qE '^\.PHONY:.*completions|^completions:' $@/Makefile 2>/dev/null; then \
		mkdir -p $(ZSH_COMPLETIONS_DIR); \
		$(MAKE) -C $@ completions; \
	else \
		echo "==> Skipping $@ (no completions target)"; \
	fi

# Install shared skills once, before either client (including parallel installs).
opencode copilot: agents

$(CLEAN):
	$(MAKE) -C $(basename $@) clean

# Per-module plugin upgrade: delegates to `<module>/Makefile#upgrade` when it
# exists, otherwise skips (same UX as the completions hook above). Honors
# LOCAL_MODULES / OPTIONAL_MODULES via $(TARGETS).
# NOTE: explicit list (not a %.upgrade pattern rule) — GNU make skips
# implicit rule search for .PHONY targets, so a pattern rule would never fire.
$(UPGRADE):
	@if grep -qE '^\.PHONY:.*upgrade|^upgrade:' $(basename $@)/Makefile 2>/dev/null; then \
		$(MAKE) -C $(basename $@) upgrade; \
	else \
		echo "==> Skipping $(basename $@) (no upgrade target)"; \
	fi

all: $(MODULES) ## Install all modules (parallel)

# Single entrypoint for fresh installs and updates — delegates to ./install so
# context detection (fresh vs existing machine) lives in one place.
install: ## Install or update this machine in any context (runs ./install)
	@./install

update: install ## Update an existing machine (alias for `install`)

clean.all: $(CLEAN) ## Clean all modules

outdated: ## Show outdated tools (no changes)
	@mise outdated || true
	@echo ""
	@echo "Tip: 'mise outdated --bump' shows versions outside pinned ranges (bumps stay manual)."

doctor: ## Diagnose install state (read-only; offline unless ARGS=--online)
	@scripts/state doctor $(ARGS)

status: ## Show repository, applied, and filesystem state (read-only)
	@scripts/state status $(ARGS)

lint: ## Lint shell scripts (bash -n, shellcheck, shfmt)
	@fail=0; \
	for f in $(SHELL_SCRIPTS); do \
		bash -n "$$f" || fail=1; \
	done; \
	if [ -n "$(SHELLCHECK)" ]; then \
		$(SHELLCHECK) -x $(SHELL_SCRIPTS) || fail=1; \
	else \
		echo "error: shellcheck not found — run 'mise install'" >&2; fail=1; \
	fi; \
	if [ -n "$(SHFMT)" ]; then \
		$(SHFMT) -d $(SHFMT_FLAGS) $(SHELL_SCRIPTS) || fail=1; \
	else \
		echo "error: shfmt not found — run 'mise install'" >&2; fail=1; \
	fi; \
	exit $$fail

fmt: ## Format shell scripts with shfmt
	@if [ -n "$(SHFMT)" ]; then \
		$(SHFMT) -w $(SHFMT_FLAGS) $(SHELL_SCRIPTS); \
	else \
		echo "error: shfmt not found — run 'mise install'" >&2; exit 1; \
	fi

upgrade.tools: ## Upgrade mise tools within pinned ranges + refresh completions
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

.PHONY: $(TARGETS) $(CLEAN) $(UPGRADE) install update all clean.all outdated doctor status lint fmt upgrade.tools prune.tools upgrade.plugins upgrade.all

help: ## Show this help message
	@echo "Available targets:"; \
	echo; \
	awk 'BEGIN {FS="##"; printf "\x1b[1;34m%-20s\x1b[0m %s\n","Target","Description"; print "-------------------- ----------------------------"} /^[a-zA-Z0-9_.-]+:/ && $$1 !~ /^\./ {split($$1,parts,":"); target=parts[1]; gsub(/^[ \t]+|[ \t]+$$/,"",target); desc=($$2?$$2:"No description"); gsub(/^[ \t]+/,"",desc); printf "\x1b[36m%-20s\x1b[0m %s\n",target,desc}' $(MAKEFILE_LIST); \
	echo; \
	echo "Usage:"; \
	echo "  make <target>       # Run a specific target"; \
	echo "  make install        # Install or update this machine (runs ./install)"; \
	echo "  make update         # Update an existing machine (alias for install)"; \
	echo "  make all            # Relink all modules (parallel; no pull/top-up/prune)"; \
	echo "  make clean.all      # Clean all modules"; \
	echo "  make <module>.clean # Clean a specific module, e.g. 'make zsh.clean'"; \
	echo "  make outdated       # Preview outdated tools (no changes)"; \
	echo "  make doctor         # Diagnose install state (read-only)"; \
	echo "  make status         # Show repo, applied, and filesystem state"; \
	echo "  make lint           # Check shell scripts (bash -n, shellcheck, shfmt)"; \
	echo "  make fmt            # Format shell scripts with shfmt"; \
	echo "  make upgrade.tools  # Upgrade mise tools within pinned ranges"; \
	echo "  make prune.tools    # Remove superseded mise tool versions"; \
	echo "  make upgrade.plugins # Upgrade editor/shell plugins"; \
	echo "  make upgrade.all    # Upgrade tools + plugins"
