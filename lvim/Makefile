include ../env.mk

install: 
	mv $(XDG_CONFIG_HOME)/lvim/config.lua $(XDG_CONFIG_HOME)/lvim/config_backup.lua
	ln -sfn $(CURDIR)/config.lua $(XDG_CONFIG_HOME)/lvim/config.lua
	lvim +PackerClean +PackerSync +qa

clean: 
	rm -rf $(XDG_CONFIG_HOME)/lvim/config.lua
	mv $(XDG_CONFIG_HOME)/lvim/config_backup.lua $(XDG_CONFIG_HOME)/lvim/config.lua
	lvim +PackerClean +PackerSync +qa
.PHONY: install clean
