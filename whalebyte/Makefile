include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/whalebyte
	mkdir -p ~/.whalebyte/notes
	touch .env .secret

clean: .remove.xdg.module.whalebyte
	rm -rf $(XDG_CONFIG_HOME)/whalebyte

.PHONY: install clean
