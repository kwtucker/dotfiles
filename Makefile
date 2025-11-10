# include modules.local.mk

		# bin zsh whalebyte alacritty python fzf tmux git golang \
	  # bat nvim psql ripgrep rust homebrew $(LOCAL_MODULES)
MODULES = \
		bin zsh whalebyte alacritty fzf tmux git golang \
	  bat nvim psql ripgrep $(LOCAL_MODULES)

CLEAN := $(addsuffix .clean,$(MODULES))

$(MODULES): local
	$(MAKE) -C $@

$(CLEAN):
	$(MAKE) -C $(basename $@) clean

local:
	test -e modules.local.mk || touch modules.local.mk

all: $(MODULES) ## Make it all

clean.all: $(CLEAN)

.PHONY: $(MODULES) $(CLEAN) all clean.all

help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'



