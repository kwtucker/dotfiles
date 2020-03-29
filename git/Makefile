include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/git

clean: .remove.xdg.module.git

.PHONY: install clean
