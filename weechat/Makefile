include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/weechat

clean: .remove.xdg.module.weechat
	rm -rf $(XDG_CONFIG_HOME)/weechat

.PHONY: install clean
