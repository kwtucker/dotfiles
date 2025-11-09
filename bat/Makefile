include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/bat

clean: .remove.xdg.module.bat

.PHONY: install clean
