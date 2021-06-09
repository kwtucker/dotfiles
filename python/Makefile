include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/python
	@pip3 install -U -r $(CURDIR)/requirements.txt
	@npm install -g pyright

clean: .remove.xdg.module.python
	@pip3 uninstall -y -r $(CURDIR)/requirements.txt
	rm -rf $(XDG_CONFIG_HOME)/python
	@npm uninstall -g pyright

.PHONY: install clean