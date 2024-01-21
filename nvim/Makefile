include ../env.mk

install: .ensure.xdg
	rm -rf ~/.config/nvim
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/nvim

clean: .remove.xdg.module.nvim

.PHONY: install clean
