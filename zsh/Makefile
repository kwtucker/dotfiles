include ../env.mk

install: .ensure.xdg
	mkdir -p $(XDG_CACHE_HOME)/zsh
	mkdir -p $(XDG_DATA_HOME)/zsh
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/zsh
	ln -sf $(CURDIR)/zshenv $(HOME)/.zshenv

clean: .remove.xdg.module.zsh
	rm -f $(HOME)/.zshenv

.PHONY: install clean
