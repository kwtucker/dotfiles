include ../env.mk

install: .ensure.xdg
	ln -sfn $(CURDIR) $(XDG_CONFIG_HOME)/tmux
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	~/.tmux/plugins/tpm/scripts/install_plugins.sh
	# If already in a tmux session run:
	tmux source-file ~/.config/tmux/tmux.conf

clean: .remove.xdg.module.tmux
	rm -rf $(XDG_CONFIG_HOME)/tmux

.PHONY: install clean
