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
mkdir -p ~/.whalebyte/{Code,notes} ; touch ~/.whalebyte/.secret .env
```

##### 2. Clone dotfiles repo to ~/.whalebyte directory

```
git clone git@github.com:kwtucker/dotfiles.git  ~/.whalebyte/dotfiles
```

##### 3. Setup dotfile components

*NOTE*: Make sure if needed to create local files first:
 - git: [user] name and email and [url] instead of mapping
 - zsh: environment variables with usernames and tokens set.

```shell
git/config.local
zsh/local.zsh
```

Setup dotfile with make targert

```shell
cd ~/.whalebyte/dotfiles
make all 
```

##### 4. Then install vim plugins.

*Install*: [vim-plug](https://github.com/junegunn/vim-plug)

```shell
  $ vim
  :PlugInstall
```

## Credits

Influneced by and examples taken from:

[mnarrell](https://github.com/mnarrell/dotfiles)

