include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/golang
	curl -sSfL "https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh" | sh -s -- -b ~/go/bin latest

clean: .remove.xdg.module.golang
	rm ~/go/bin/golangci-lint

.PHONY: install clean
