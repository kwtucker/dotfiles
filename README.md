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
mkdir -p ~/.whalebyte/{Code,notes} ; touch ~/{.whalebyte_secrets,.whalebyte_envs}
```

##### 2. Clone dotfiles repo to ~/.whalebyte directory

```
git clone git@github.com:kwtucker/dotfiles.git  ~/.whalebyte/dotfiles
```

##### 3. Run Setup.

```
ln -s ~/.whalebyte/dotfiles/.zsh_functions ~/.zsh_functions && source ~/.zsh_functions && envsetup
```

##### 6. Then you must install your plugins.

In the home directory enter the following:

```shell
  $ vim

  :PluginInstall
  :q
```
