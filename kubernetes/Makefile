include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/kubernetes

clean: .remove.xdg.module.kubernetes

.PHONY: install clean
