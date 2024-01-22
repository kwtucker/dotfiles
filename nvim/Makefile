include ../env.mk

install: .ensure.xdg
	rm -rf $(XDG_CONFIG_HOME)/nvim
	rm -rf $(XDG_DATA_HOME)/nvim
	rm -rf ~/.local/state/nvim
	rm -rf $(XDG_CACHE_HOME)~/.cache/nvim
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/nvim

clean: .remove.xdg.module.nvim

.PHONY: install clean
