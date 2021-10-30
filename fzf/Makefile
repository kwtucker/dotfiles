include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git && $(CURDIR)/fzf/install --all --xdg --no-update-rc --no-bash 

clean: .remove.xdg.module.fzf
	rm -rf fzf fzf.zsh fzf.bash

.PHONY: install clean
