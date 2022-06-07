include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/asdf
	@touch ~/.tool-versions
	@asdf plugin-add nodejs
	asdf install nodejs latest
	@asdf plugin-add golang
	asdf install golang latest
	@asdf plugin-add golangci-lint
	@asdf plugin-add python
	asdf install python latest

clean: .remove.xdg.module.asdf
	rm -rf $(XDG_CONFIG_HOME)/asdf
	rm -rf ~/.asdf

.PHONY: install clean
