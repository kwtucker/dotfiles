include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/git

clean:
	rm -rf $(XDG_CONFIG_HOME)/git

.PHONY: install clean
