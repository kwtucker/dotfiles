include ../env.mk


install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/nvim

clean: .remove.xdg.module.nvim

.PHONY: install clean
