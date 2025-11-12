include ../env.mk

install: .remove.xdg.module.nvim .ensure.xdg
	rm -rf ~/.local/state/nvim
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/nvim

clean: .remove.xdg.module.nvim

.PHONY: install clean
