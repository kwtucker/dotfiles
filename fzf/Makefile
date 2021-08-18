include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/fzf
	$(HOMEBREW_PREFIX)/opt/fzf/install --all --xdg --no-update-rc

clean: .remove.xdg.module.fzf

.PHONY: install clean
