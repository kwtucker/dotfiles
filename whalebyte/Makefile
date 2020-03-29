include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/whalebyte

clean: .remove.xdg.module.whalebyte

.PHONY: install clean
