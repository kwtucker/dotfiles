# Dotfiles

## Intstallation:

Link to the brew command - [Brew](https://brew.sh/)

Brew Install

```
brew update
brew bundle
brew tap homebrew/services
brew services start nats-server
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

##### 3. Setup dotfile components

```
cd ~/.whalebyte/dotfiles
make install
```

##### 3. Then you must install your plugins.

In the home directory enter the following:

```shell
  $ vim

  :PluginInstall
  :q
```

## Credits

Influneced by and examples taken from:

[mnarrell](https://github.com/mnarrell/dotfiles)

