include ../env.mk

install: .ensure.xdg
	mkdir -p $(XDG_DATA_HOME)/nvim
	ln -s ~/.vim $XDG_CONFIG_HOME/nvim
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/nvim


clean: .remove.xdg.module.zsh
	rm -f $(XDG_CONFIG_HOME)/nvim

.PHONY: install clean
