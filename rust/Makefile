MODULE_NAME := rust

.PHONY: install clean

install:
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
	@cargo install stylua
	@echo "✅ $(MODULE_NAME) installed."

clean:
	@echo "Cleaning $(MODULE_NAME) data..."
	@rustup self uninstall
	@echo "✅ $(MODULE_NAME) cleaned."
