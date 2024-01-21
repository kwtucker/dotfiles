include ../env.mk

install: .ensure.xdg
	mv $(XDG_CONFIG_HOME)/nvim{,.bak}
	mv $(XDG_DATA_HOME)/nvim{,.bak}
	mv ~/.local/state/nvim{,.bak}
	mv $(XDG_CACHE_HOME)~/.cache/nvim{,.bak}
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/nvim

clean: .remove.xdg.module.nvim

.PHONY: install clean
