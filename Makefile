SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

# If the file doesn't exist it will not error.
-include modules.local.mk

# Shared XDG vars (also makes ZSH_COMPLETIONS_DIR available below).
include env.mk

MODULES = \
	  bin zsh alacritty fzf tmux git golang kubernetes helm terraform docker \
	  bat nvim psql ripgrep fonts rust opencode $(LOCAL_MODULES)

# Optional modules — installed on demand (`make <module>`), not part of `make all`.
# Currently none; keep the mechanism for future use.
OPTIONAL_MODULES =

TARGETS := $(MODULES) $(OPTIONAL_MODULES)

CLEAN := $(addsuffix .clean,$(TARGETS))

UPGRADE := $(addsuffix .upgrade,$(TARGETS))

# Modules with a `completions` target — completions are refreshed after tool upgrades.
COMPLETION_MODULES := kubernetes helm fzf ripgrep

$(TARGETS):
	$(MAKE) -C $@ install
	@if grep -qE '^\.PHONY:.*completions|^completions:' $@/Makefile 2>/dev/null; then \
		mkdir -p $(ZSH_COMPLETIONS_DIR); \
		$(MAKE) -C $@ completions; \
	else \
		echo "==> Skipping $@ (no completions target)"; \
	fi

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

all: $(MODULES) ## Make it all

clean.all: $(CLEAN) ## Clean all modules

outdated: ## Show outdated tools (laptop + workspace image, no changes)
	@echo "== mise.toml (laptop) =="
	@mise outdated || true
	@echo ""
	@echo "== image/mise.workspace.toml (workspace image) =="
	@TMPDIR=$$(mktemp -d); \
	cp $(CURDIR)/image/mise.workspace.toml "$$TMPDIR/mise.toml"; \
	mise --cd "$$TMPDIR" outdated || true; \
	rm -rf "$$TMPDIR"
	@echo ""
	@echo "Tip: 'mise outdated --bump' shows versions outside pinned ranges (bumps stay manual)."

upgrade.tools: ## Upgrade mise tools within pinned ranges + refresh completions
	@MISE_YES=1 mise upgrade --yes
	@mise reshim
	@for m in $(COMPLETION_MODULES); do \
		if grep -qE '^\.PHONY:.*completions|^completions:' $$m/Makefile 2>/dev/null; then \
			mkdir -p $(ZSH_COMPLETIONS_DIR); \
			$(MAKE) -C $$m completions; \
		fi; \
	done

upgrade.plugins: $(UPGRADE) ## Upgrade editor/shell plugins (nvim, tmux, zsh, opencode)

upgrade.all: upgrade.tools upgrade.plugins ## Upgrade tools + plugins

.PHONY: $(TARGETS) $(CLEAN) $(UPGRADE) all clean.all outdated upgrade.tools upgrade.plugins upgrade.all

help: ## Show this help message
	@echo "Available targets:"; \
	echo; \
	awk 'BEGIN {FS="##"; printf "\x1b[1;34m%-20s\x1b[0m %s\n","Target","Description"; print "-------------------- ----------------------------"} /^[a-zA-Z0-9_.-]+:/ && $$1 !~ /^\./ {split($$1,parts,":"); target=parts[1]; gsub(/^[ \t]+|[ \t]+$$/,"",target); desc=($$2?$$2:"No description"); gsub(/^[ \t]+/,"",desc); printf "\x1b[36m%-20s\x1b[0m %s\n",target,desc}' $(MAKEFILE_LIST); \
	echo; \
	echo "Usage:"; \
	echo "  make <target>       # Run a specific target"; \
	echo "  make all            # Install all modules"; \
	echo "  make clean.all      # Clean all modules"; \
	echo "  make <module>.clean # Clean a specific module, e.g. 'make zsh.clean'"; \
	echo "  make outdated       # Preview outdated tools (no changes)"; \
	echo "  make upgrade.tools  # Upgrade mise tools within pinned ranges"; \
	echo "  make upgrade.plugins # Upgrade editor/shell plugins"; \
	echo "  make upgrade.all    # Upgrade tools + plugins"

