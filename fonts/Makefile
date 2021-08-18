include ../env.mk

install: .ensure.xdg
	mkdir $(XDG_DATA_HOME)/fonts
	mkdir $(XDG_CONFIG_HOME)/fontconfig
	wget https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf
	mv Inconsolata\ for\ Powerline.otf $(XDG_DATA_HOME)/fonts/
	fc-cache -vf $(XDG_DATA_HOME)/fonts/

clean: .remove.xdg.module.fonts
	rm -rf $(XDG_CONFIG_HOME)/fontconfig
	rm -rf $(XDG_DATA_HOME)/fonts
.PHONY: install clean
