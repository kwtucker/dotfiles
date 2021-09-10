include ../env.mk

install: .ensure.xdg
	mkdir -p $(XDG_CACHE_HOME)/terraform/plugin-cache
	mkdir -p $(XDG_DATA_HOME)/terraform
	mkdir -p $(XDG_RUNTIME_DIR)/terraform
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/terraform

clean: .remove.xdg.module.terraform
	rm -rf $(XDG_CACHE_HOME)/terraform
	rm -rf $(XDG_CONFIG_HOME)/terraform
	rm -rf $(XDG_DATA_HOME)/terraform
	rm -rf $(XDG_RUNTIME_DIR)/terraform

.PHONY: install clean
