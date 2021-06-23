include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/nvim
	curl -sfLo "${XDG_CONFIG_HOME}/nvim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >> /dev/null
	mkdir -p "${XDG_DATA_HOME}/nvim/{backup,swap,undo}"
	nvim +PlugInstall +UpdateRemotePlugins +qa
	@pip3 install -U -r "requirements.txt"
	npm install -g neovim
	${GEM_HOME}/gem install neovim

clean: .remove.xdg.module.zsh
	rm -rf $(XDG_CONFIG_HOME)/nvim
	@pip3 uninstall -y -r "requirements.txt"
	npm uninstall -g neovim
	gem uninstall neovim || true
	
.PHONY: install clean
