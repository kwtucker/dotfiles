include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/golang

clean: .remove.xdg.module.golang

.PHONY: install clean
