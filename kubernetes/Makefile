include ../env.mk

KUBECTL_VERSION = 1.34.1
KUBECTL_URL = https://storage.googleapis.com/kubernetes-release/release/v$(KUBECTL_VERSION)/bin/darwin/amd64/kubectl
KUBECTL = kubectl-$(KUBECTL_VERSION)

install: .ensure.xdg $(HOME)/bin/$(KUBECTL)
	@ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/kubernetes

clean: .remove.xdg.module.kubernetes
	rm -rf $(XDG_CONFIG_HOME)/kubernetes
	rm -rf $(HOME)/.local/bin/kubectl

$(HOME)/bin/$(KUBECTL):
	@echo "Installing kubectl $(KUBECTL_VERSION)..."
	@curl $(KUBECTL_URL) -o $(HOME)/tmp/$(KUBECTL)
	@chmod +x $(HOME)/tmp/$(KUBECTL)
	@mv $(HOME)/tmp/$(KUBECTL) $(HOME)/.local/bin/$(KUBECTL)
	ln -sfn $(HOME)/.local/bin/$(KUBECTL) $(HOME)/.local/bin/kubectl

.PHONY: install clean
