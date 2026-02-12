include ../env.mk

MODULE_NAME := rust

.PHONY: install clean

install: .ensure.xdg.rust
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
	@cargo install stylua
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.rust
	@echo "Cleaning $(MODULE_NAME) data..."
	@rustup self uninstall
	@echo "✅ $(MODULE_NAME) cleaned."
