include ../env.mk

MODULE_NAME := fzf

.PHONY: install clean

install: .ensure.xdg.fzf
	@echo "Installing $(MODULE_NAME) dotfiles..."
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/$(MODULE_NAME)
	@git clone --depth 1 https://github.com/junegunn/fzf.git && $(CURDIR)/fzf/install --all --xdg --no-update-rc --no-bash --no-fish
	@echo "✅ $(MODULE_NAME) installed."

clean: .remove.xdg.fzf
	@echo "Cleaning $(MODULE_NAME) data..."
	@rm -rf fzf fzf.zsh
	@echo "✅ $(MODULE_NAME) cleaned."
