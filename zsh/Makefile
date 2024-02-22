include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/zsh
	mkdir -p $(XDG_CACHE_HOME)/zsh
	mkdir -p $(XDG_CONFIG_HOME)/zsh
	mkdir -p $(XDG_DATA_HOME)/zsh
	mkdir -p $(XDG_RUNTIME_DIR)/zsh
	curl -sS https://starship.rs/install.sh | sh
	curl -L git.io/antigen > antigen.zsh
	ln -sf $(CURDIR)/zshenv $(HOME)/.zshenv

clean: .remove.xdg.module.zsh
	rm -rf $(HOME)/.zshenv
	rm -rf $(XDG_CONFIG_HOME)/zsh
	rm -rf $(XDG_CACHE_HOME)/zsh
	rm -rf $(XDG_DATA_HOME)/zsh
	rm -rf $(XDG_RUNTIME_DIR)/zsh
	sh -c 'rm "$(command -v 'starship')"'
	rm ~/.local/bin/antibody

.PHONY: install clean
