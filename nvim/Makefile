include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/nvim
	curl -sfLo "${XDG_CONFIG_HOME}/nvim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >> /dev/null
	mkdir -p "${XDG_DATA_HOME}/nvim/{backup,swap,undo}"
	nvim +PlugInstall +qall!


clean: .remove.xdg.module.zsh
	rm -rf $(XDG_CONFIG_HOME)/nvim

.PHONY: install clean
