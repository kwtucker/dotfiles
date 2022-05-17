include ../env.mk

install: .ensure.xdg
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/k9

clean: .remove.xdg.module.bin
	rm -rf $(XDG_CONFIG_HOME)/k9

.PHONY: install clean
