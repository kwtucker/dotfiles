MODULES = git golang

CLEAN := $(addsuffix .clean,$(MODULES))

$(MODULES):
	$(MAKE) -C $@

$(CLEAN):
	$(MAKE) -C $(basename $@) clean

all: brew $(MODULES)

brew:
	brew bundle
	
clean.all: $(CLEAN)

.PHONY: $(MODULES) $(CLEAN) all clean.all