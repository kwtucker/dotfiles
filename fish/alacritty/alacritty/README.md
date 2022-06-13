For quick reference only the Debian steps are outlined. All others check out the [Alacritty INSTALL](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)

## Debian / POP OS

### Dependencies  

`sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3`

### Clone the source code

Before compiling Alacritty, you'll have to first clone the source code:

```
git clone https://github.com/alacritty/alacritty.git
cd alacritty
```

### Desktop Entry

Many Linux and BSD distributions support desktop entries for adding applications to system menus. This will install the desktop entry for Alacritty:

```
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
```

If you are having problems with Alacritty's logo, you can replace it with prerendered PNGs and simplified SVGs available in the `extra/logo/compat` directory.

### Set default terminal `SUPER + T`

```
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator (which alacritty) 50
```

Priority `50` should set it as the selected default but use the following command to check:

```
sudo update-alternatives --config x-terminal-emulator
```