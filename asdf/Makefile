include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/asdf
	@touch ~/.tool-versions
	asdf plugin add nodejs
	asdf install nodejs latest
	asdf global nodejs latest
	asdf plugin add golang
	asdf install golang latest
	asdf global golang latest
	asdf plugin add golangci-lint
	asdf install golangci-lint latest
	asdf global golangci-lint latest
	asdf plugin add python
	asdf install python latest
	asdf global python latest
	asdf plugin add git
	asdf install git latest
	asdf global git latest
	asdf plugin add jq
	asdf install jq latest
	asdf global jq latest
	asdf plugin add sops
	asdf install sops latest
	asdf global sops latest
	asdf plugin add age
	asdf install age latest
	asdf global age latest
	asdf plugin add bat
	asdf install bat latest
	asdf global bat latest
	asdf plugin add terraform
	asdf install terraform latest
	asdf global terraform latest
	asdf plugin add terraform-docs
	asdf install terraform-docs latest
	asdf global terraform-docs latest
	asdf plugin add kubectl
	asdf install kubectl 1.23.6
	asdf global kubectl 1.23.6
	asdf plugin add helm
	asdf install helm latest
	asdf global helm latest
	asdf plugin add awscli
	asdf install awscli latest
	asdf global awscli latest
	asdf plugin add aws-iam-authenticator
	asdf install aws-iam-authenticator latest
	asdf global aws-iam-authenticator latest

clean: .remove.xdg.module.asdf
	rm -rf $(XDG_CONFIG_HOME)/asdf
	rm -rf ~/.asdf

.PHONY: install clean
