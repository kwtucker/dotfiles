include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/homebrew

clean: .remove.xdg.module.homebrew
	rm -rf $(XDG_CONFIG_HOME)/homebrew

.PHONY: install clean
