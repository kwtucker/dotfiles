include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/whalebyte 
	mkdir -p ~/.whalebyte/notes
	mkdir -p ~/.whalebyte/code
	touch ~/.whalebyte/.env ~/.whalebyte/.secret

clean: .remove.xdg.module.whalebyte
	rm -rf $(XDG_CONFIG_HOME)/whalebyte

.PHONY: install clean
