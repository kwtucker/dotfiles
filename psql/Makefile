include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/psql
	mkdir -p $(XDG_CACHE_HOME)/psql

clean: .remove.xdg.module.psql

.PHONY: install clean
