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

all: $(MODULES) ## Make it all

clean.all: $(CLEAN) ## Clean all modules

.PHONY: $(TARGETS) $(CLEAN) all clean.all

help: ## Show this help message
	@echo "Available targets:"; \
	echo; \
	awk 'BEGIN {FS="##"; printf "\x1b[1;34m%-20s\x1b[0m %s\n","Target","Description"; print "-------------------- ----------------------------"} /^[a-zA-Z0-9_.-]+:/ && $$1 !~ /^\./ {split($$1,parts,":"); target=parts[1]; gsub(/^[ \t]+|[ \t]+$$/,"",target); desc=($$2?$$2:"No description"); gsub(/^[ \t]+/,"",desc); printf "\x1b[36m%-20s\x1b[0m %s\n",target,desc}' $(MAKEFILE_LIST); \
	echo; \
	echo "Usage:"; \
	echo "  make <target>       # Run a specific target"; \
	echo "  make all            # Install all modules"; \
	echo "  make clean.all      # Clean all modules"; \
	echo "  make <module>.clean # Clean a specific module, e.g. 'make zsh.clean'"

