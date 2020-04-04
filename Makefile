MODULES = zsh fzf kubernetes tmux whalebyte git golang bat nvim

CLEAN := $(addsuffix .clean,$(MODULES))

$(MODULES):
	$(MAKE) -C $@

$(CLEAN):
	$(MAKE) -C $(basename $@) clean

all: $(MODULES)

clean.all: $(CLEAN)

.PHONY: $(MODULES) $(CLEAN) all clean.all
