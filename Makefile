SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

# If the file doesn't exist it will not error.
-include modules.local.mk

MODULES = \
	  bin zsh alacritty fzf tmux git golang kubernetes helm docker \
	  bat nvim psql ripgrep $(LOCAL_MODULES)

CLEAN := $(addsuffix .clean,$(MODULES))

$(MODULES):
	$(MAKE) -C $@ install

$(CLEAN):
	$(MAKE) -C $(basename $@) clean

all: $(MODULES) ## Make it all

clean.all: $(CLEAN) ## Clean all modules

.PHONY: $(MODULES) $(CLEAN) all clean.all


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

