include ../env.mk

HELM_VERSION = 3.19.0
HELM_URL = https://get.helm.sh/helm-v$(HELM_VERSION)-darwin-amd64.tar.gz
HELM = helm-$(HELM_VERSION)

install: .ensure.xdg $(HOME)/bin/$(HELM)
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/helm

clean: .remove.xdg.module.helm
	rm -rf $(XDG_CONFIG_HOME)/helm
	rm -rf $(HOME)/bin/helm
	rm -rf $(HOME)/bin/$(HELM)

$(HOME)/bin/$(HELM):
	@echo "Installing helm $(HELM_VERSION)..."
	@curl -s $(HELM_URL) | tar xz -C $(HOME)/tmp
	@chmod +x $(HOME)/tmp/darwin-amd64/helm
	@mkdir -p $(HOME)/bin
	@cp $(HOME)/tmp/darwin-amd64/helm $(HOME)/bin/$(HELM)
	ln -sfn $(HOME)/bin/$(HELM) $(HOME)/bin/helm
	@rm -rf $(HOME)/tmp/darwin-amd64

.PHONY: install clean
