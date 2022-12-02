include ../env.mk

install:
	mv $(XDG_CONFIG_HOME)/lvim $(XDG_CONFIG_HOME)/lvim-backup
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)
	lvim +PackerClean +PackerSync

clean:
	curl -s "https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/uninstall.sh" | bash 
	rm -rf $(XDG_CONFIG_HOME)/lvim 
	rm -rf $(XDG_CONFIG_HOME)/lvim-backup
.PHONY: install clean
