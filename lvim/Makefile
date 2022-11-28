include ../env.mk

install: 
	LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
	mv $(XDG_CONFIG_HOME)/lvim $(XDG_CONFIG_HOME)/lvim-backup
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)
	lvim +PackerClean +PackerSync +qa

clean: 
	lvim +PackerClean +PackerSync +qa
	rm -rf $(XDG_CONFIG_HOME)/lvim
	rm -rf $(XDG_DATA_HOME)/lunarvim
	rm -rf $(XDG_CACHE_HOME)/lvim
.PHONY: install clean
