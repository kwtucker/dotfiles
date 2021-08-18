include ../env.mk

install: .ensure.xdg
	@mkdir -p $(HOME)/bin
	ln -sf $(CURDIR)/* $(HOME)/bin

clean: .remove.xdg.module.bin
	rm -rf $(HOME)/bin

.PHONY: install clean
