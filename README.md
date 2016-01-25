#Dotfiles


For the prompt you can also reference: http://neverstopbuilding.com/gitpro 

###Intstallation:
```
  cd ~
  
  git clone git@github.com:kwtucker/dotfiles.git
``` 

###Create symlinks

```
  ln -s ~/dotfiles/.vimrc ~/.vimrc
  
  ln -s ~/dotfiles/.bash_profile ~/.bash_profile
  
  ln -s ~/dotfiles/.vim ~/.vim
  
  ln -s ~/dotfiles/.gitconfig ~/.gitconfig
  
  ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
```

#####Set up [Vundle] (in the home directory):
```
   $ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
#####Then you must install your plugins.
In the home directory enter the following:
```
  vim 
  :PluginInstall
  :q 

