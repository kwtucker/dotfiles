include ../env.mk

install: .ensure.xdg
	@mkdir -p $(HOME)/.local/bin

clean: .remove.xdg.module.bin
	rm -rf $(HOME)/.local/bin

.PHONY: install clean
