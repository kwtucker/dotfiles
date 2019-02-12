# Dotfiles

### Intstallation:

##### Install Brew ( Mac OS ) & Oh My ZSH

Link to the brew command - [Brew](https://brew.sh/)

Brew Install

```
 brew update
 brew install httpie tldr vim tmux git ctags asciinema mongodb mariadb nvm tree yarn
 brew tap homebrew/services
 brew services start mariadb
 brew services start mongodb
 brew services list
```

Install [Oh My ZSH](https://github.com/robbyrussell/oh-my-zsh)

```
 sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

##### 1. Go to ~/.whalebyte directory

```
 cd ~
 mkdir .whalebyte
```

##### 2. Clone dotfiles repo to ~/.whalebyte directory

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
 ln -s ~/.whalebyte/dotfiles/.vimrc ~/.vimrc

 ln -s ~/.whalebyte/dotfiles/.bash_profile ~/.bash_profile

 ln -s ~/.whalebyte/dotfiles/.gitconfig ~/.gitconfig

 ln -s ~/.whalebyte/dotfiles/.tmux.conf ~/.tmux.conf

 ln -s ~/.whalebyte/dotfiles/.zshrc ~/.zshrc

 ln -s ~/.whalebyte/dotfiles/.zsh_functions ~/.zsh_functions

 ln -s ~/.whalebyte/dotfiles/.zsh_aliases ~/.zsh_aliases
```

##### 5. Set up [Vundle] (in the home directory):

```
 $ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

##### 6. Then you must install your plugins.

In the home directory enter the following:

```shell
  $ vim

  :PluginInstall
  :q
```
