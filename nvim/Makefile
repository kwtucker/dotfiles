include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/nvim
	mkdir -p "${XDG_DATA_HOME}/nvim/backup"
	mkdir -p "${XDG_DATA_HOME}/nvim/swap"
	mkdir -p "${XDG_DATA_HOME}/nvim/undo"
	brew install --HEAD luajit
	brew install --HEAD tree-sitter
	brew install --HEAD neovim
	npm install -g \
		bash-language-server \
		neovim
	yarn global add vim-language-server
	nvim +PackerClean +PackerSync +qa

clean: .remove.xdg.module.nvim
	brew uninstall tree-sitter luajit neovim
	cargo uninstall stylua
	npm uninstall -g bash-language-server neovim
	yarn global remove vim-language-server
.PHONY: install clean
