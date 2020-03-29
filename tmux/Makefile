include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/tmux

clean: .remove.xdg.module.tmux

.PHONY: install clean
