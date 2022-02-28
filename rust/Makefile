include ../env.mk

install: 
	@curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
	cargo install stylua

clean: 
	rustup self uninstall
.PHONY: install clean
