include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/gem
	mkdir -p $(XDG_DATA_HOME)/gem
	mkdir -p $(XDG_CACHE_HOME)/gem

clean: .remove.xdg.module.gem
	rm -rf $(XDG_CONFIG_HOME)/gem
	rm -rf $(XDG_DATA_HOME)/gem
	rm -rf $(XDG_CACHE_HOME)/gem

.PHONY: install clean
