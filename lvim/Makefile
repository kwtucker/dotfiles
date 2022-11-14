include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/lvim

clean: .remove.xdg.module.nvim
	rm -rf $(XDG_CONFIG_HOME)/lvim
.PHONY: install clean
