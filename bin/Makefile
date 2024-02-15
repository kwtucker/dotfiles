include ../env.mk

install: .ensure.xdg
	@mkdir -p $(HOME)/.local/bin

clean: .remove.xdg.module.bin
	rm -rf $(HOME)/bin

.PHONY: install clean
