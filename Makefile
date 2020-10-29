MODULES = gnu zsh fzf kubernetes tmux whalebyte git golang bat nvim weechat docker helm psql ripgrep

CLEAN := $(addsuffix .clean,$(MODULES))

$(MODULES):
	mkdir -p $(HOME)/bin
	$(MAKE) -C $@

$(CLEAN):
	rm -rf $(HOME)/bin
	$(MAKE) -C $(basename $@) clean

all: $(MODULES)

clean.all: $(CLEAN)

.PHONY: $(MODULES) $(CLEAN) all clean.all
