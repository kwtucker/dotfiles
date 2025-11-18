# include modules.local.mk

MODULES = \
	  bin zsh whalebyte alacritty fzf tmux git golang kubectl helm docker \
	  bat nvim psql ripgrep $(LOCAL_MODULES)

CLEAN := $(addsuffix .clean,$(MODULES))

$(MODULES): local
	$(MAKE) -C $@ install

$(CLEAN):
	$(MAKE) -C $(basename $@) clean

local:
	test -e modules.local.mk || touch modules.local.mk

all: $(MODULES) ## Make it all

nix: ## Build and install the Nix tool environment
	@nix-env -i -f nix/default.nix

nix.install: ## Install Nix and the environment
	@scripts/install-nix.sh

clean.all: $(CLEAN)

.PHONY: $(MODULES) $(CLEAN) all clean.all nix nix.install

help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
