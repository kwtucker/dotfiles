SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

# If the file doesn't exist it will not error.
-include modules.local.mk

MODULES = \
	  bin zsh whalebyte alacritty fzf tmux git golang kubernetes helm docker \
	  bat nvim psql ripgrep $(LOCAL_MODULES)

CLEAN := $(addsuffix .clean,$(MODULES))

$(MODULES): local
	$(MAKE) -C $@ install

$(CLEAN):
	$(MAKE) -C $(basename $@) clean

all: $(MODULES) ## Make it all

clean.all: $(CLEAN)

.PHONY: $(MODULES) $(CLEAN) all clean.all

help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
