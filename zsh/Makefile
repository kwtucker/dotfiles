include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/zsh
	mkdir -p $(XDG_CACHE_HOME)/zsh
	mkdir -p $(XDG_CONFIG_HOME)/zsh
	mkdir -p $(XDG_DATA_HOME)/zsh
	mkdir -p $(XDG_RUNTIME_DIR)/zsh
	curl -sfL "git.io/antibody" | sh -s - -b $(HOME)/bin
	/home/kevin/bin/antibody bundle < $(CURDIR)/bundle.txt > ${XDG_DATA_HOME}/zsh/plugins
	ln -sf $(CURDIR)/zshenv $(HOME)/.zshenv

clean: .remove.xdg.module.zsh
	rm -rf $(HOME)/.zshenv
	rm -rf $(XDG_CONFIG_HOME)/zsh
	rm -rf $(XDG_CACHE_HOME)/zsh
	rm -rf $(XDG_DATA_HOME)/zsh
	rm -rf $(XDG_RUNTIME_DIR)/zsh

.PHONY: install clean
