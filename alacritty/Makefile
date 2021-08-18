include ../env.mk


install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/alacritty

clean: .remove.xdg.module.alacritty

.PHONY: install clean
