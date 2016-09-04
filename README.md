#Dotfiles

###Intstallation:

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
```

##### 5. Set up [Vundle] (in the home directory):
```
   $ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
##### 6. Then you must install your plugins.
In the home directory enter the following:
```
  vim
  :PluginInstall
  :q
```
