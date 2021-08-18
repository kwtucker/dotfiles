include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/ripgrep

clean: .remove.xdg.module.ripgrep
	rm -rf $(XDG_CONFIG_HOME)/ripgrep

.PHONY: install clean
