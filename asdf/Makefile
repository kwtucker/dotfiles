include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/asdf
	@touch ~/.tool-versions
	asdf plugin add nodejs
	asdf install nodejs latest
	asdf plugin add python
	asdf install python latest
	asdf plugin add git
	asdf install git latest
	asdf plugin add jq
	asdf install jq latest
	asdf plugin add sops
	asdf install sops latest
	asdf plugin add age
	asdf install age latest
	asdf plugin add bat
	asdf install bat latest
	asdf plugin add kubectl
	asdf install kubectl 1.23.6
	asdf plugin add helm
	asdf install helm latest
	asdf plugin add awscli
	asdf install awscli latest
	asdf plugin add aws-iam-authenticator
	asdf install aws-iam-authenticator latest

clean: .remove.xdg.module.asdf
	rm -rf $(XDG_CONFIG_HOME)/asdf
	rm -rf ~/.asdf

.PHONY: install clean
