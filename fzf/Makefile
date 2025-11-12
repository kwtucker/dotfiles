include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git && $(CURDIR)/fzf/install --all --xdg --no-update-rc --no-bash --no-fish

clean: .remove.xdg.module.fzf
	rm -rf fzf fzf.zsh

.PHONY: install clean
