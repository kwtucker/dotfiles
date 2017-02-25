#Dotfiles

###Intstallation:

##### Install Brew ( Mac OS ) & Oh My ZSH
Link to the brew command - [Brew](https://brew.sh/)

Install [neovimi](https://github.com/neovim/neovim/wiki/Installing-Neovim)
```
 brew install neovim/neovim/neovim
```

Install [Oh My ZSH](https://github.com/robbyrussell/oh-my-zsh)
```
 sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

##### 1. Go to Home directory
```
  cd ~
```

##### 2. Clone dotfiles repo to home directory
```

  git clone git@github.com:kwtucker/dotfiles.git
```

##### 3. Create a parent directory .vim and sub-directory bundle in the Home directory.
```
mkdir ~/.vim/bundle
```

```
 .vim
  |_ bundle
```

##### 4. Create symlinks

```
  ln -s ~/dotfiles/.vimrc ~/.vimrc

  ln -s ~/dotfiles/.bash_profile ~/.bash_profile

  ln -s ~/dotfiles/.gitconfig ~/.gitconfig

  ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

  ln -s ~/dotfiles/.zshrc ~/.zshrc
  
  ln -s ~/.vim ~/.config/nvim

  ln -s ~/.vimrc ~/.config/nvim/init.vim
```

##### 5. Set up [Vundle] (in the home directory):
```
   $ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
##### 6. Then you must install your plugins.
In the home directory enter the following:
```
	$ vim

  -In vim enter these commands
  :PluginInstall
  :q
```
