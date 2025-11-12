include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/docker

clean: .remove.xdg.module.docker

.PHONY: install clean
