include ../env.mk

install: .ensure.xdg
	git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
	mkdir -p $(XDG_CACHE_HOME)/terraform/plugin-cache
	mkdir -p $(XDG_DATA_HOME)/terraform
	mkdir -p $(XDG_RUNTIME_DIR)/terraform
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/terraform
	go install github.com/terraform-docs/terraform-docs@v0.19.0

clean: .remove.xdg.module.terraform
	rm -rf $(XDG_RUNTIME_DIR)/terraform
	rm ~/go/bin/terraform-docs

.PHONY: install clean
