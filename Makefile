MODULES = \
	bin zsh gnu python fzf kubernetes helm tmux \
	whalebyte git golang bat nvim weechat docker psql ripgrep 

CLEAN := $(addsuffix .clean,$(MODULES))

$(MODULES):
	$(MAKE) -C $@

$(CLEAN):
	$(MAKE) -C $(basename $@) clean
	
all: $(MODULES) ## Make it all

clean.all: $(CLEAN)

.PHONY: $(MODULES) $(CLEAN) all clean.all

help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'



